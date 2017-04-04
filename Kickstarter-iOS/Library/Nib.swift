import UIKit

public enum Nib: String {
  case LiveStreamChatInputView
  case LiveStreamNavTitleView
  case NoRewardCell
  case PledgeTitleCell
  case RewardCell
  case RewardsTitleCell
}

extension UITableView {
  public func register(nib: Nib, inBundle bundle: Bundle = .framework) {
    self.register(UINib(nibName: nib.rawValue, bundle: bundle), forCellReuseIdentifier: nib.rawValue)
  }
}
