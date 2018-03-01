import Foundation

public struct MessageThreadsEnvelope: Swift.Decodable {
  public let messageThreads: [MessageThread]
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Swift.Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope: Swift.Decodable {
      public let moreMessageThreads: String
    }
  }
}

extension MessageThreadsEnvelope {
  enum CodingKeys: String, CodingKey {
    case messageThreads = "message_threads",
    urls
  }
}

extension MessageThreadsEnvelope.UrlsEnvelope.ApiEnvelope {
  enum CodingKeys: String, CodingKey {
    case moreMessageThreads = "more_message_threads"
  }
}
