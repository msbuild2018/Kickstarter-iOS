import Foundation

public struct User: Swift.Decodable {
  public let avatar: Avatar
  public let facebookConnected: Bool?
  public let id: Int
  public let isFriend: Bool?
  public let liveAuthToken: String?
  public let location: Location?
  public let name: String
  public let newsletters: NewsletterSubscriptions
  public let notifications: Notifications
  public let social: Bool?
  public let stats: Stats

  public struct Avatar: Swift.Decodable, Swift.Encodable {
    public let large: String?
    public let medium: String
    public let small: String
  }

  public struct NewsletterSubscriptions: Swift.Decodable, Swift.Encodable {
    public let arts: Bool?
    public let games: Bool?
    public let happening: Bool?
    public let invent: Bool?
    public let promo: Bool?
    public let weekly: Bool?
  }

  public struct Notifications: Swift.Decodable, Swift.Encodable {
    public let backings: Bool?
    public let comments: Bool?
    public let follower: Bool?
    public let friendActivity: Bool?
    public let mobileBackings: Bool?
    public let mobileComments: Bool?
    public let mobileFollower: Bool?
    public let mobileFriendActivity: Bool?
    public let mobilePostLikes: Bool?
    public let mobileUpdates: Bool?
    public let postLikes: Bool?
    public let creatorTips: Bool?
    public let updates: Bool?
    public let creatorDigest: Bool?
  }

  public struct Stats: Swift.Decodable, Swift.Encodable {
    public let backedProjectsCount: Int?
    public let createdProjectsCount: Int?
    public let memberProjectsCount: Int?
    public let starredProjectsCount: Int?
    public let unansweredSurveysCount: Int?
    public let unreadMessagesCount: Int?
  }

  public var isCreator: Bool {
    return (self.stats.createdProjectsCount ?? 0) > 0
  }
}

extension User: EncodableType {
  enum CodingKeys: String, CodingKey {
    case avatar,
    facebookConnected = "facebook_connected",
    id,
    isFriend = "is_friend",
    liveAuthToken = "ksr_live_token",
    location,
    name,
    newsletters,
    notifications,
    social,
    stats
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.avatar = try values.decode(User.Avatar.self, forKey: .avatar)
    self.facebookConnected = try? values.decode(Bool.self, forKey: .facebookConnected)
    self.id = try values.decode(Int.self, forKey: .id)
    self.isFriend = try? values.decode(Bool.self, forKey: .isFriend)
    self.liveAuthToken = try? values.decode(String.self, forKey: .liveAuthToken)
    self.location = try? values.decode(Location.self, forKey: .location)
    self.name = try values.decode(String.self, forKey: .name)
    self.newsletters = try User.NewsletterSubscriptions(from: decoder)
    self.notifications = try User.Notifications(from: decoder)
    self.social = try? values.decode(Bool.self, forKey: .social)
    self.stats = try User.Stats(from: decoder)
  }

  public func encode() -> [String: Any] {

    var result: [String: Any] = [:]
    result["avatar"] = self.avatar.encode()
    result["facebook_connected"] = self.facebookConnected ?? false
    result["id"] = self.id
    result["is_friend"] = self.isFriend ?? false
    result["ksr_live_token"] = self.liveAuthToken
    result["location"] = self.location?.encode()
    result["name"] = self.name
    result = result.withAllValuesFrom(self.newsletters.encode())
    result = result.withAllValuesFrom(self.notifications.encode())
    result = result.withAllValuesFrom(self.stats.encode())

    return result
  }
}

extension User.NewsletterSubscriptions: EncodableType {

  enum CodingKeys: String, CodingKey {
    case arts = "arts_culture_newsletter",
    games = "games_newsletter",
    happening = "happening_newsletter",
    invent = "invent_newsletter",
    promo = "promo_newsletter",
    weekly = "weekly_newsletter"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.arts = try? container.decode(Bool.self, forKey: .arts)
    self.games = try? container.decode(Bool.self, forKey: .games)
    self.happening = try? container.decode(Bool.self, forKey: .happening)
    self.invent = try? container.decode(Bool.self, forKey: .invent)
    self.promo = try? container.decode(Bool.self, forKey: .promo)
    self.weekly = try? container.decode(Bool.self, forKey: .weekly)
  }

  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["games_newsletter"] = self.games
    result["happening_newsletter"] = self.happening
    result["promo_newsletter"] = self.promo
    result["weekly_newsletter"] = self.weekly
    return result
  }
}

extension User.Notifications: EncodableType {

    public func encode() -> [String: Any] {
      var result: [String: Any] = [:]
      result["notify_of_backings"] = self.backings
      result["notify_of_comments"] = self.comments
      result["notify_of_follower"] = self.follower
      result["notify_of_friend_activity"] = self.friendActivity
      result["notify_of_post_likes"] = self.postLikes
      result["notify_of_updates"] = self.updates
      result["notify_mobile_of_backings"] = self.mobileBackings
      result["notify_mobile_of_comments"] = self.mobileComments
      result["notify_mobile_of_follower"] = self.mobileFollower
      result["notify_mobile_of_friend_activity"] = self.mobileFriendActivity
      result["notify_mobile_of_post_likes"] = self.mobilePostLikes
      result["notify_mobile_of_updates"] = self.mobileUpdates
      return result
  }
}

extension User.Stats: EncodableType {

  enum CodkingKeys: String, CodingKey {
    case backedProjectsCount = "backed_projects_count",
    createdProjectsCount = "created_projects_count",
    memberProjectsCount = "member_projects_count",
    starredProjectsCount = "starred_projects_count",
    unansweredSurveysCount = "unanswered_surveys_count",
    unreadMessagesCount = "unread_messages_count"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backedProjectsCount = try? container.decode(Int.self, forKey: .backedProjectsCount)
    self.createdProjectsCount = try? container.decode(Int.self, forKey: .createdProjectsCount)
    self.memberProjectsCount = try? container.decode(Int.self, forKey: .memberProjectsCount)
    self.starredProjectsCount = try? container.decode(Int.self, forKey: .starredProjectsCount)
    self.unansweredSurveysCount = try? container.decode(Int.self, forKey: .unansweredSurveysCount)
    self.unreadMessagesCount = try? container.decode(Int.self, forKey: .unreadMessagesCount)
  }

  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["backed_projects_count"] =  self.backedProjectsCount
    result["created_projects_count"] = self.createdProjectsCount
    result["member_projects_count"] = self.memberProjectsCount
    result["starred_projects_count"] = self.starredProjectsCount
    result["unanswered_surveys_count"] = self.unansweredSurveysCount
    result["unread_messages_count"] =  self.unreadMessagesCount
    return result
  }
}

extension User: Equatable {}
public func == (lhs: User, rhs: User) -> Bool {
  return lhs.id == rhs.id
}

extension User: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "User(id: \(id), name: \"\(name)\")"
  }
}

extension User.Avatar: EncodableType {
  public func encode() -> [String: Any] {
    var ret: [String: Any] = [
      "medium": self.medium,
      "small": self.small
    ]

    ret["large"] = self.large

    return ret
  }
}

extension User.NewsletterSubscriptions: Equatable {}
public func == (lhs: User.NewsletterSubscriptions, rhs: User.NewsletterSubscriptions) -> Bool {
  return lhs.arts == rhs.arts &&
    lhs.games == rhs.games &&
    lhs.happening == rhs.happening &&
    lhs.invent == rhs.invent &&
    lhs.promo == rhs.promo &&
    lhs.weekly == rhs.weekly
}

extension User.Notifications: Equatable {}
public func == (lhs: User.Notifications, rhs: User.Notifications) -> Bool {
  return lhs.backings == rhs.backings &&
    lhs.comments == rhs.comments &&
    lhs.follower == rhs.follower &&
    lhs.friendActivity == rhs.friendActivity &&
    lhs.mobileBackings == rhs.mobileBackings &&
    lhs.mobileComments == rhs.mobileComments &&
    lhs.mobileFollower == rhs.mobileFollower &&
    lhs.mobileFriendActivity == rhs.mobileFriendActivity &&
    lhs.mobilePostLikes == rhs.mobilePostLikes &&
    lhs.mobileUpdates == rhs.mobileUpdates &&
    lhs.postLikes == rhs.postLikes &&
    lhs.creatorTips == rhs.creatorTips &&
    lhs.updates == rhs.updates &&
    lhs.creatorDigest == rhs.creatorDigest
}
