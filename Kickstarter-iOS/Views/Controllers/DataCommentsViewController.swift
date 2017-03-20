import UIKit
import Library
import Prelude
import KsApi

final class DataCommentsViewController: UITableViewController {

  private let dataSource = DataCommentsDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.dataSource = self.dataSource
    self.tableView.reloadData()

    //self.dataSource.load(comments: <#T##[Comment]#>)
    //AppEnvironment.current.apiService.fetchComments(project: <#T##Project#>)

    AppEnvironment.current.apiService.fetchProject(param: Param.slug("superscreen"))

  }

  override func bindStyles() {
    super.bindStyles()
    _ = self
      |> baseTableControllerStyle()
  }
}
