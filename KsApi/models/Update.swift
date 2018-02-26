import Foundation

public struct Update: Swift.Decodable {
  public let body: String?
  public let commentsCount: Int?
  public let hasLiked: Bool?
  public let id: Int
  public let isPublic: Bool
  public let likesCount: Int?
  public let projectId: Int
  public let publishedAt: TimeInterval?
  public let sequence: Int
  public let title: String
  public let urls: UrlsEnvelope
  public let user: User?
  public let visible: Bool?

  public struct UrlsEnvelope: Swift.Decodable {
    public let web: WebEnvelope

    public struct WebEnvelope: Swift.Decodable {
      public let update: String
    }
  }
}

extension Update {
  enum CodingKeys: String, CodingKey {
    case body,
    commentsCount = "comments_count",
    hasLiked = "has_liked",
    id,
    isPublic = "public",
    likesCount = "likes_count",
    projectId = "project_id",
    publishedAt = "published_at",
    sequence,
    title,
    urls,
    user,
    visible
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.body = try? values.decode(String.self, forKey: .body)
    self.commentsCount = try? values.decode(Int.self, forKey: .commentsCount)
    self.hasLiked = try? values.decode(Bool.self, forKey: .hasLiked)
    self.id = try values.decode(Int.self, forKey: .id)
    self.isPublic = try values.decode(Bool.self, forKey: .isPublic)
    self.likesCount = try? values.decode(Int.self, forKey: .likesCount)
    self.projectId = try values.decode(Int.self, forKey: .projectId)
    self.publishedAt = try? values.decode(TimeInterval.self, forKey: .publishedAt)
    self.sequence = try values.decode(Int.self, forKey: .sequence)
    self.title = try values.decode(String.self, forKey: .title)
    self.urls = try values.decode(Update.UrlsEnvelope.self, forKey: .urls)
    self.user = try? values.decode(User.self, forKey: .user)
    self.visible = try? values.decode(Bool.self, forKey: .visible)
  }
}

extension Update: Equatable {
}
public func == (lhs: Update, rhs: Update) -> Bool {
  return lhs.id == rhs.id
}
