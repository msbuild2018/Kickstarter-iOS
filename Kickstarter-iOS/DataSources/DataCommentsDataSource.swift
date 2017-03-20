import Library
import KsApi

final class DataCommentsDataSource: ValueCellDataSource {

  func load(comments: [Comment]) {
    self.set(values: comments,
             cellClass: DataCommentCell.self,
             inSection: 0)
  }

  override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
    switch (cell, value) {
    case let (cell as DataCommentCell, value as Comment):
      cell.configureWith(value: value)
    default:
      assertionFailure()
    }
  }
}
