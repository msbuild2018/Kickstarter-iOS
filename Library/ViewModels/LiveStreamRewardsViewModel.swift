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
}

public protocol LiveStreamRewardsViewModelOutputs {
  /// Emits the Project to be loaded into the data source.
  var loadProjectIntoDataSource: Signal<Project, NoError> { get }
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
//    let liveStreamEvent = configData.map(second)

    self.loadProjectIntoDataSource = project
  }

  private let configDataProperty = MutableProperty<(Project, LiveStreamEvent)?>(nil)
  public func configure(withProject project: Project, liveStreamEvent: LiveStreamEvent) {
    self.configDataProperty.value = (project, liveStreamEvent)
  }

  private let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  public let loadProjectIntoDataSource: Signal<Project, NoError>

  public var inputs: LiveStreamRewardsViewModelInputs { return self }
  public var outputs: LiveStreamRewardsViewModelOutputs { return self }
}
