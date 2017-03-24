import UIKit
import Library
import Prelude
@testable import KsApi

internal final class MessageTableViewController: UITableViewController {

  private let dataSource = MessageTableDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.dataSource = self.dataSource
      AppEnvironment.current.apiService.fetchMessageThreads(mailbox: .inbox, project: nil)
        .map { $0.messageThreads.first?.id }
        .skipNil()
        .flatMap {
          AppEnvironment.current.apiService.fetchMessageThread(messageThreadId: $0)
        }
        .map { $0.messages }
        .demoteErrors()
        .observeForUI()
        .startWithValues { messages in
          self.dataSource.load(messages: messages)
          self.tableView.reloadData()
      }

  }

  override func bindStyles() {
    super.bindStyles()
    _ = self
      |> baseTableControllerStyle()
  }
}
