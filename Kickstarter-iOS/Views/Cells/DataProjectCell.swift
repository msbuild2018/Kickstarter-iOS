import UIKit
import Library
import AlamofireImage

struct DataProject {
  let name: String
  let creatorName: String
  let image: String
}

final class DataProjectCell: UITableViewCell, ValueCell {
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var creatorNameLabel: UILabel!
  @IBOutlet private weak var projectImageView: UIImageView!

  func configureWith(value: DataProject) {
    self.nameLabel.text = value.name
    self.creatorNameLabel.text = value.creatorName
    self.projectImageView.image = nil
    self.projectImageView.af_setImage(withURL: URL(string: value.image)!)
  }
}
