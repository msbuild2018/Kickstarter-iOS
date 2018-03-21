import Foundation

public struct Activity: Swift.Decodable {
  public let category: Activity.Category
  public let comment: Comment?
  public let createdAt: TimeInterval
  public let id: Int
  public let memberData: MemberData
  public let project: Project?
  public let update: Update?
  public let user: User?

  public enum Category: String, Swift.Decodable {
    case backing          = "backing"
    case backingAmount    = "backing-amount"
    case backingCanceled  = "backing-canceled"
    case backingDropped   = "backing-dropped"
    case backingReward    = "backing-reward"
    case cancellation     = "cancellation"
    case commentPost      = "comment-post"
    case commentProject   = "comment-project"
    case failure          = "failure"
    case follow           = "follow"
    case funding          = "funding"
    case launch           = "launch"
    case success          = "success"
    case suspension       = "suspension"
    case update           = "update"
    case watch            = "watch"
    case unknown          = "unknown"
  }

  public struct MemberData: Swift.Decodable {
    public let amount: Int?
    public let backing: Backing?
    public let oldAmount: Int?
    public let oldRewardId: Int?
    public let newAmount: Int?
    public let newRewardId: Int?
    public let rewardId: Int?
  }
}

extension Activity: Equatable {
}
public func == (lhs: Activity, rhs: Activity) -> Bool {
  return lhs.id == rhs.id
}

extension Activity {
  enum CodingKeys: String, CodingKey {
    case category,
    comment,
    createdAt = "created_at",
    id,
    memberData,
    project,
    update,
    user
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.category = try values.decode(Activity.Category.self, forKey: .category)
    self.comment = try? values.decode(Comment.self, forKey: .comment)
    self.createdAt = try values.decode(TimeInterval.self, forKey: .createdAt)
    self.id = try values.decode(Int.self, forKey: .id)
    self.memberData = try Activity.MemberData(from: decoder)
    self.project = try? values.decode(Project.self, forKey: .project)
    self.update = try? values.decode(Update.self, forKey: .update)
    self.user = try? values.decode(User.self, forKey: .user)
  }
}

//extension Activity.Category {
//  public static func decode(_ json: JSON) -> Decoded<Activity.Category> {
//    switch json {
//    case let .string(category):
//      return .success(Activity.Category(rawValue: category) ?? .unknown)
//    default:
//      return .failure(.typeMismatch(expected: "String", actual: json.description))
//    }
//  }
//}

extension Activity.MemberData {
  enum CodingKeys: String, CodingKey {
    case amount,
    backing,
    oldAmount = "old_amount",
    oldRewardId = "old_reward_id",
    newAmount = "new_amount",
    newRewardId = "new_reward_id",
    rewardId = "reward_id"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.amount = try? values.decode(Int.self, forKey: .amount)
    self.backing = try? values.decode(Backing.self, forKey: .backing)
    self.oldAmount = try? values.decode(Int.self, forKey: .oldAmount)
    self.oldRewardId = try? values.decode(Int.self, forKey: .oldRewardId)
    self.newAmount = try? values.decode(Int.self, forKey: .newAmount)
    self.newRewardId = try? values.decode(Int.self, forKey: .newRewardId)
    self.rewardId = try? values.decode(Int.self, forKey: .rewardId)
  }
}
