import Foundation

public struct ProjectActivityEnvelope: Swift.Decodable {
  public let activities: [Activity]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Swift.Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope: Swift.Decodable {
      public let moreActivities: String
    }
  }
}

extension ProjectActivityEnvelope.UrlsEnvelope.ApiEnvelope {
  enum CodingKeys: String, CodingKey {
    case moreActivities = "more_activities"
  }
}
