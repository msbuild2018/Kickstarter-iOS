import UIKit
import Library
import Prelude
@testable import KsApi
import ReactiveSwift

final class DataCommentsViewController: UITableViewController {

  private let dataSource = DataCommentsDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.dataSource = self.dataSource

    AppEnvironment.current.apiService.fetchMessageThreads(mailbox: .inbox, project: nil)
      .flatMap { env -> SignalProducer<[Message], ErrorEnvelope> in
        guard let messageThread = env.messageThreads.first else { return .empty }

        return AppEnvironment.current.apiService.fetchMessageThread(messageThreadId: messageThread.id)
          .map { env in env.messages }
    }

    AppEnvironment.current.apiService.fetchProject(param: Param.slug("superscreen"))
      .switchMap { p in
        AppEnvironment.current.apiService.fetchComments(project: p)
      }
      .observeForUI()
      .start { event in
        guard let comments = event.value?.comments else { return }

        self.dataSource.load(comments: comments)
        self.tableView.reloadData()
    }
  }

  override func bindStyles() {
    super.bindStyles()
    _ = self
      |> baseTableControllerStyle()
  }
}
