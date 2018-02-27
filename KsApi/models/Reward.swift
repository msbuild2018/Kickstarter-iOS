import Foundation

public struct Reward: Swift.Decodable {
  public let backersCount: Int?
  public let description: String
  public let endsAt: TimeInterval?
  public let estimatedDeliveryOn: TimeInterval?
  public let id: Int
  public let limit: Int?
  public let minimum: Int
  public let remaining: Int?
  public let rewardsItems: [RewardsItem]
  public let shipping: Shipping
  public let startsAt: TimeInterval?
  public let title: String?

  /// Returns `true` is this is the "fake" "No reward" reward.
  public var isNoReward: Bool {
    return self.id == Reward.noReward.id
  }

  public struct Shipping: Swift.Decodable {
    public let enabled: Bool
    public let preference: Preference?
    public let summary: String?

    public enum Preference: String {
      case none
      case restricted
      case unrestricted
    }
  }
}

extension Reward: Equatable {}
public func == (lhs: Reward, rhs: Reward) -> Bool {
  return lhs.id == rhs.id
}

private let minimumAndIdComparator = Reward.lens.minimum.comparator <> Reward.lens.id.comparator

extension Reward: Comparable {}
public func < (lhs: Reward, rhs: Reward) -> Bool {
  return minimumAndIdComparator.isOrdered(lhs, rhs)
}

extension Reward {
  enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count",
    description,
    endsAt = "ends_at",
    estimatedDeliveryOn = "estimated_delivery_on",
    id,
    limit,
    minimum,
    remaining,
    rewardsItems = "rewards_items",
    shipping,
    startsAt = "starts_at",
    title
  }

}

extension Reward.Shipping {
  enum CodingKeys: String, CodingKey {
    case enabled = "shipping_enabled",
    preference = "shipping_preference",
    summary = "shipping_summary"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.enabled = try values.decode(Bool.self, forKey: .enabled)
    self.preference = try? values.decode(Preference.self, forKey: .preference)
    self.summary = try? values.decode(String.self, forKey: .summary)
  }
}
