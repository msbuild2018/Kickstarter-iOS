import UIKit
import Library
import KsApi
import AlamofireImage

final class DataCommentCell: UITableViewCell, ValueCell {

  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var bodyLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var userImageView: UIImageView!

  func configureWith(value: Comment) {
    self.nameLabel.text = value.author.name
    self.bodyLabel.text = value.body
    self.dateLabel.text = Date(timeIntervalSince1970: value.createdAt).description
    self.userImageView.image = nil
    self.userImageView.af_setImage(withURL: URL(string: value.author.avatar.medium)!)
  }
}
