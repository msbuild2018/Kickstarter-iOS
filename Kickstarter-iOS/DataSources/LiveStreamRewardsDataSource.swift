import KsApi
import Library
import Prelude

internal final class LiveStreamRewardsDataSource: ValueCellDataSource {
  internal enum Section: Int {
    case pledgeTitle
    case calloutReward
    case rewardsTitle
    case rewards
  }

  internal func loadMinimal(project: Project) {
    self.setRewardTitleArea(project: project)
  }

  internal func load(project: Project) {
    self.clearValues()

    self.setRewardTitleArea(project: project)

    let rewardData = project.rewards
      .filter { isMainReward(reward: $0, project: project) }
      .sorted()
      .map { (project, Either<Reward, Backing>.left($0), RewardCellContext.liveStream) }

    if !rewardData.isEmpty {
      self.set(values: [(project, .liveStream)],
               cellClass: RewardsTitleCell.self, inSection: Section.rewardsTitle.rawValue)
      self.set(values: rewardData, cellClass: RewardCell.self, inSection: Section.rewards.rawValue)
    }
  }

  private func setRewardTitleArea(project: Project) {
    if project.personalization.isBacking != true && project.state == .live {
      self.set(values: [(project, .liveStream)],
               cellClass: PledgeTitleCell.self, inSection: Section.pledgeTitle.rawValue)
      self.set(values: [(project, .liveStream)],
               cellClass: NoRewardCell.self, inSection: Section.calloutReward.rawValue)
    } else if let backing = project.personalization.backing {

      self.set(values: [(project, .liveStream)],
               cellClass: PledgeTitleCell.self, inSection: Section.pledgeTitle.rawValue)
      self.set(values: [(project, .right(backing), .liveStream)],
               cellClass: RewardCell.self,
               inSection: Section.calloutReward.rawValue)
    }
  }

  internal func indexPathIsPledgeAnyAmountCell(_ indexPath: IndexPath) -> Bool {
    guard let (project, _) = self[indexPath] as? (Project, RewardCellContext) else {
      return false
    }

    return project.personalization.isBacking != true
      && project.state == .live
      && indexPath.item == 0
      && indexPath.section == Section.calloutReward.rawValue
  }

  internal override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {

    switch (cell, value) {
    case let (cell as RewardCell, value as (Project, Either<Reward, Backing>, RewardCellContext)):
      cell.configureWith(value: value)
    case let (cell as PledgeTitleCell, value as (Project, RewardCellContext)):
      cell.configureWith(value: value)
    case let (cell as NoRewardCell, value as (Project, RewardCellContext)):
      cell.configureWith(value: value)
    case let (cell as RewardsTitleCell, value as (Project, RewardCellContext)):
      cell.configureWith(value: value)
    default:
      fatalError("Unrecognized (\(type(of: cell)), \(type(of: value))) combo.")
    }
  }
}

private func backingReward(fromProject project: Project) -> Reward? {

  guard let backing = project.personalization.backing else {
    return nil
  }

  return project.rewards
    .filter { $0.id == backing.rewardId || $0.id == backing.reward?.id }
    .first
    .coalesceWith(.noReward)
}

// Determines if a reward belongs in the main list of rewards.
private func isMainReward(reward: Reward, project: Project) -> Bool {
  // Don't show the no-reward reward
  guard reward.id != 0 else { return false }
  // Don't show the reward the user is backing
  guard .some(reward.id) != project.personalization.backing?.rewardId else { return false }
  // Show all rewards when the project isn't live
  guard project.state == .live else { return true }

  let now = AppEnvironment.current.dateType.init().timeIntervalSince1970
  let startsAt = reward.startsAt ?? 0
  let endsAt = (reward.endsAt == .some(0) ? nil : reward.endsAt) ?? project.dates.deadline

  return startsAt <= now && now <= endsAt
}
