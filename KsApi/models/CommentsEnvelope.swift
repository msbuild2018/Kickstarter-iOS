import Foundation

public struct CommentsEnvelope: Swift.Decodable {
  public let comments: [Comment]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Swift.Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope: Swift.Decodable {
      public let moreComments: String
    }
  }
}

extension CommentsEnvelope.UrlsEnvelope.ApiEnvelope {
  enum CodingKeys: String, CodingKey {
    case moreComments = "more_comments"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.moreComments = try values.decode(String.self, forKey: .moreComments)
  }
}
