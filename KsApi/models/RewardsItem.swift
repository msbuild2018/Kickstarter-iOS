import Foundation

public struct RewardsItem: Swift.Decodable {
  public let id: Int
  public let item: Item
  public let quantity: Int
  public let rewardId: Int
}

extension RewardsItem {
  enum CodingKeys: String, CodingKey {
    case id, item, quantity, rewardId = "reward_id"
  }
}
