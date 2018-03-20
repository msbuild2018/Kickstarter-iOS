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

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.item = try Item(from: decoder)
    self.quantity = try container.decode(Int.self, forKey: .quantity)
    self.rewardId = try container.decode(Int.self, forKey: .rewardId)
  }
}
