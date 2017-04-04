import KsApi
import Library
import LiveStream
import Prelude
import ReactiveSwift

internal final class LiveStreamRewardsViewController: UITableViewController {

  private let viewModel = LiveStreamRewardsViewModel()
  private let dataSource = LiveStreamRewardsDataSource()

  internal static func configured(withProject project: Project, liveStreamEvent: LiveStreamEvent) -> LiveStreamRewardsViewController {
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
  }
}
