import KsApi
import Library
import LiveStream
import Prelude
import ReactiveSwift

internal final class LiveStreamRewardsViewController: UITableViewController {

  private let viewModel = LiveStreamRewardsViewModel()
  private let dataSource = LiveStreamRewardsDataSource()

  internal static func configured(withProject project: Project, liveStreamEvent: LiveStreamEvent) ->
    LiveStreamRewardsViewController {
    let vc = Storyboard.LiveStream.instantiate(LiveStreamRewardsViewController.self)
    vc.viewModel.inputs.configure(withProject: project, liveStreamEvent: liveStreamEvent)
    return vc
  }

  internal override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.dataSource = self.dataSource

    self.tableView.register(nib: .RewardCell)
    self.tableView.register(nib: .PledgeTitleCell)
    self.tableView.register(nib: .NoRewardCell)
    self.tableView.register(nib: .RewardsTitleCell)

    self.viewModel.inputs.viewDidLoad()
  }

  internal override func bindStyles() {
    super.bindStyles()

    _ = self
      |> baseLiveStreamControllerStyle()

    _ = self
      |> (UITableViewController.lens.tableView • UITableView.lens.delaysContentTouches) .~ false
      |> (UITableViewController.lens.tableView • UITableView.lens.canCancelContentTouches) .~ true
      |> UITableViewController.lens.view.backgroundColor .~ .ksr_navy_700
      |> UITableViewController.lens.tableView.separatorStyle .~ .none
      |> UITableViewController.lens.tableView.rowHeight .~ UITableViewAutomaticDimension
      |> UITableViewController.lens.tableView.estimatedRowHeight .~ 450
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.loadProjectIntoDataSource
      .observeForUI()
      .observeValues { [weak self] in
        self?.dataSource.load(project: $0)
    }

    self.viewModel.outputs.goToRewardPledge
      .observeForControllerAction()
      .observeValues { [weak self] project, reward in
        self?.goToRewardPledge(project: project, reward: reward)
    }

    self.viewModel.outputs.goToBacking
      .observeForControllerAction()
      .observeValues { [weak self] in self?.goToBacking(project: $0) }
  }

  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let (_, rewardOrBacking, _) = self.dataSource[indexPath] as? (Project, Either<Reward, Backing>,
      RewardCellContext) {
      self.viewModel.inputs.tapped(rewardOrBacking: rewardOrBacking)
    } else if self.dataSource.indexPathIsPledgeAnyAmountCell(indexPath) {
      self.viewModel.inputs.tappedPledgeAnyAmount()
    }
  }

  public override func tableView(_ tableView: UITableView,
                                 willDisplay cell: UITableViewCell,
                                 forRowAt indexPath: IndexPath) {
    if let cell = cell as? RewardCell {
      cell.delegate = self
    }
  }

  fileprivate func goToRewardPledge(project: Project, reward: Reward) {
    let vc = RewardPledgeViewController.configuredWith(project: project, reward: reward)
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = UIModalPresentationStyle.formSheet
    self.present(nav, animated: true, completion: nil)
  }

  fileprivate func goToBacking(project: Project) {
    let vc = BackingViewController.configuredWith(project: project, backer: nil)

    if self.traitCollection.userInterfaceIdiom == .pad {
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = UIModalPresentationStyle.formSheet
      self.present(nav, animated: true, completion: nil)
    } else {
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension LiveStreamRewardsViewController: RewardCellDelegate {
  internal func rewardCellWantsExpansion(_ cell: RewardCell) {
    cell.contentView.setNeedsUpdateConstraints()
    self.tableView.beginUpdates()
    self.tableView.endUpdates()
  }
}
