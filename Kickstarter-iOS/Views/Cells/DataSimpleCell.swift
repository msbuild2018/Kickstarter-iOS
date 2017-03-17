import UIKit
import Library

internal final class DataSimpleCell: UITableViewCell, ValueCell {

  @IBOutlet private weak var simpleLabel: UILabel!

  func configureWith(value: String) {
    self.simpleLabel.text = value
  }
}
