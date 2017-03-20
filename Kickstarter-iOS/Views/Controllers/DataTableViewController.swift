import UIKit
import Library
import Prelude

internal final class DataTableViewController: UITableViewController {

  private let dataSource = DataTableDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self.dataSource
    self.dataSource.load()
    self.tableView.reloadData()
  }

  override func bindStyles() {
    super.bindStyles()
    _ = self
      |> baseTableControllerStyle()
  }
}
