import KsApi
import LiveStream
import Prelude
import ReactiveSwift
import ReactiveExtensions
import Result

public protocol LiveStreamRewardsViewModelType {
  var inputs: LiveStreamRewardsViewModelInputs { get }
  var outputs: LiveStreamRewardsViewModelOutputs { get }
}

public protocol LiveStreamRewardsViewModelInputs {
  /// Call to configure with the Project and LiveStreamEvent.
  func configure(withProject project: Project, liveStreamEvent: LiveStreamEvent)

  /// Call when the viewDidLoad.
  func viewDidLoad()

  /// Call when pledge any amount is tapped.
  func tappedPledgeAnyAmount()

  /// Call when reward or backing is tapped.
  func tapped(rewardOrBacking: Either<Reward, Backing>)
}

public protocol LiveStreamRewardsViewModelOutputs {
  /// Emits the Project to be loaded into the data source.
  var loadProjectIntoDataSource: Signal<Project, NoError> { get }

  /// Emits when we should navigate to Backing.
  var goToBacking: Signal<Project, NoError> { get }

  /// Emits when we should navigate to Reward Pledge.
  var goToRewardPledge: Signal<(Project, Reward), NoError> { get }
}

public final class LiveStreamRewardsViewModel: LiveStreamRewardsViewModelType,
LiveStreamRewardsViewModelInputs, LiveStreamRewardsViewModelOutputs {

  public init() {
    let configData = Signal.combineLatest(
      self.configDataProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
      )
      .map(first)

    let project = configData.map(first)

    let rewardOrBackingTapped = Signal.merge(
      self.tappedRewardOrBackingProperty.signal.skipNil(),
      self.tappedPledgeAnyAmountProperty.signal.mapConst(.left(Reward.noReward))
    )

    self.goToRewardPledge = project
      .takePairWhen(rewardOrBackingTapped)
      .map(goToRewardPledgeData(forProject:rewardOrBacking:))
      .skipNil()

    self.goToBacking = project
      .takePairWhen(rewardOrBackingTapped)
      .map(goToBackingData(forProject:rewardOrBacking:))
      .skipNil()

    self.loadProjectIntoDataSource = project
  }

  private let configDataProperty = MutableProperty<(Project, LiveStreamEvent)?>(nil)
  public func configure(withProject project: Project, liveStreamEvent: LiveStreamEvent) {
    self.configDataProperty.value = (project, liveStreamEvent)
  }

  fileprivate let tappedPledgeAnyAmountProperty = MutableProperty()
  public func tappedPledgeAnyAmount() {
    self.tappedPledgeAnyAmountProperty.value = ()
  }

  fileprivate let tappedRewardOrBackingProperty = MutableProperty<Either<Reward, Backing>?>(nil)
  public func tapped(rewardOrBacking: Either<Reward, Backing>) {
    self.tappedRewardOrBackingProperty.value = rewardOrBacking
  }

  private let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  public let loadProjectIntoDataSource: Signal<Project, NoError>
  public let goToBacking: Signal<Project, NoError>
  public let goToRewardPledge: Signal<(Project, Reward), NoError>

  public var inputs: LiveStreamRewardsViewModelInputs { return self }
  public var outputs: LiveStreamRewardsViewModelOutputs { return self }
}

private func reward(forBacking backing: Backing, inProject project: Project) -> Reward? {

  return backing.reward
    ?? project.rewards.filter { $0.id == backing.rewardId }.first
    ?? Reward.noReward
}

private func goToRewardPledgeData(forProject project: Project, rewardOrBacking: Either<Reward, Backing>)
  -> (Project, Reward)? {

    guard project.state == .live else { return nil }

    switch rewardOrBacking {
    case let .left(reward):
      guard reward.remaining != .some(0) else { return nil }
      return (project, reward)

    case let .right(backing):
      guard let reward = reward(forBacking: backing, inProject: project) else { return nil }

      return (project, reward)
    }
}

private func goToBackingData(forProject project: Project, rewardOrBacking: Either<Reward, Backing>)
  -> Project? {

    guard project.state != .live && rewardOrBacking.right != nil else {
      return nil
    }

    return project
}
