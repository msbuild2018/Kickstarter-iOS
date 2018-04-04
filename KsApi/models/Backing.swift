import Foundation

public struct Backing: Swift.Decodable {
  public let amount: Int
  public let backer: User?
  public let backerId: Int
  public let id: Int
  public let locationId: Int?
  public let pledgedAt: TimeInterval
  public let projectCountry: String
  public let projectId: Int
  public let reward: Reward?
  public let rewardId: Int?
  public let sequence: Int
  public let shippingAmount: Int?
  public let status: Status

  public enum Status: String, Swift.Decodable {
    case canceled
    case collected
    case dropped
    case errored
    case pledged
    case preauth
  }
}

extension Backing: Equatable {}
public func == (lhs: Backing, rhs: Backing) -> Bool {
  return lhs.id == rhs.id
}

extension Backing {
  enum CodingKeys: String, CodingKey {
    case amount,
    backer,
    backerId = "backer_id",
    id,
    locationId = "location_id",
    pledgedAt = "pledged_at",
    projectCountry = "project_country",
    projectId = "project_id",
    reward,
    rewardId = "reward_id",
    sequence,
    shippingAmount = "shipping_amount",
    status
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.amount = try values.decode(Int.self, forKey: .amount)
    self.backer = try? values.decode(User.self, forKey: .backer)
    self.backerId = try values.decode(Int.self, forKey: .backerId)
    self.id = try values.decode(Int.self, forKey: .id)
    self.locationId = try? values.decode(Int.self, forKey: .locationId)
    self.pledgedAt = try values.decode(TimeInterval.self, forKey: .pledgedAt)
    self.projectCountry = try values.decode(String.self, forKey: .projectCountry)
    self.projectId = try values.decode(Int.self, forKey: .projectId)
    self.reward = try? values.decode(Reward.self, forKey: .backer)
    self.rewardId = try? values.decode(Int.self, forKey: .rewardId)
    self.sequence = try values.decode(Int.self, forKey: .sequence)
    self.shippingAmount = try? values.decode(Int.self, forKey: .shippingAmount)
    self.status = try values.decode(Status.self, forKey: .status)
  }
}
