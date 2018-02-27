import Foundation

public struct FriendStatsEnvelope: Swift.Decodable {
  public let stats: Stats

  public struct Stats: Swift.Decodable {
    public let friendProjectsCount: Int
    public let remoteFriendsCount: Int
  }
}

extension FriendStatsEnvelope.Stats {
  enum CodingKeys: String, CodingKey {
    case friendProjectCount = "friend_projects_count",
    remoteFriendsCount = "remote_friends_count"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.friendProjectsCount = try values.decode(Int.self, forKey: .friendProjectCount)
    self.remoteFriendsCount = try values.decode(Int.self, forKey: .remoteFriendsCount)
  }
}
