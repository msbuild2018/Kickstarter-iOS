import Library
import KsApi

final class MessageTableDataSource: ValueCellDataSource {

  func load(messages: [Message]) {
    self.set(values: messages,
             cellClass: MessageDataMessageCell.self,
             inSection: 0)
  }

  override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
    switch(cell, value) {
    case let (cell as MessageDataMessageCell, value as Message):
      cell.configureWith(value: value)
    default:
      assertionFailure()
    }
  }
}
