import UIKit
import Library
import Prelude
@testable import KsApi

internal final class MessageTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let messageThread = (1...10).map { MessageThread.template |> MessageThread.lens.id .~ $0 }

 //AppEnvironment.current.apiService.fetchMessageThread(messageThreadId: messageThread)

  //  AppEnvironment.current.apiService.fetchMessageThread(messageThreadId: messageThread)
  }

  override func bindStyles() {
    super.bindStyles()
    _ = self
      |> baseTableControllerStyle()
  }
}
