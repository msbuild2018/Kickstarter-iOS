import UIKit
import Library
import KsApi
import AlamofireImage


final class MessageDataMessageCell: UITableViewCell, ValueCell {

  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var messageBodyLabel: UILabel!
  @IBOutlet private weak var userImageView: UIImageView!

  func configureWith(value: Message) {
    self.nameLabel.text = value.sender.name
    self.dateLabel.text = Date(timeIntervalSince1970: value.createdAt).description
    self.messageBodyLabel.text = value.body
    self.userImageView.image = nil
    self.userImageView.af_setImage(withURL: URL(string: value.sender.avatar.medium)!)
  }
}

