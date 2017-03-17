import UIKit
import Library
import AlamofireImage

internal struct DataUser {
  let name: String
  let image: String
}

internal final class DataPictureCell: UITableViewCell, ValueCell {

  @IBOutlet private weak var pictureImageView: UIImageView!
  @IBOutlet private weak var pictureLabel: UILabel!

  func configureWith(value: DataUser) {
    self.pictureLabel.text = value.name
    self.pictureImageView.af_setImage(withURL: URL(string: value.image)!)
  }
}
