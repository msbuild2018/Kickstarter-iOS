import Library

final class DataTableDataSource: ValueCellDataSource {

  func load() {
    self.appendRow(value: "Christella", cellClass: DataSimpleCell.self, toSection: 0)
    self.appendRow(value: DataUser(name: "Christella", image: "https://pbs.twimg.com/profile_images/818301064927547394/OKpvHYMa_400x400.jpg"),
                   cellClass: DataPictureCell.self,
                   toSection: 0)
    self.appendRow(value: "Lisa", cellClass: DataSimpleCell.self, toSection: 0)
    self.appendRow(value: "Gina", cellClass: DataSimpleCell.self, toSection: 0)
    self.appendRow(
      value: DataProject(
        name: "MOLD: The First Print Magazine About the Future of Food",
        creatorName: "MOLD",
        image: "https://ksr-ugc.imgix.net/assets/015/699/728/fd06409178881aa163313a2509a57659_original.jpg?w=1024&h=576&fit=fill&bg=000000&v=1488470277&auto=format&q=92&s=25f9e39b4f2fb15bf95615602959ad0f"
      ),
      cellClass: DataProjectCell.self,
      toSection: 0
    )
    self.appendRow(value: "Maggie", cellClass: DataSimpleCell.self, toSection: 0)
    self.appendRow(value: "Katie", cellClass: DataSimpleCell.self, toSection: 0)
  }

  override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {

    switch (cell, value) {
    case let (cell as DataSimpleCell, value as String):
      cell.configureWith(value: value)
    case let (cell as DataPictureCell, value as DataUser):
      cell.configureWith(value: value)
    case let (cell as DataProjectCell, value as DataProject):
      cell.configureWith(value: value)
    default:
      assertionFailure()
    }
  }
}
