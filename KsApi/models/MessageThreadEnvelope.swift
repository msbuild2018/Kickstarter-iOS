import Foundation

public struct MessageThreadEnvelope: Swift.Decodable {
  public let participants: [User]
  public let messages: [Message]
  public let messageThread: MessageThread
}

extension MessageThreadEnvelope {
  enum CodingKeys: String, CodingKey {
    case participants,
    messages,
    messageThread = "message_thread"
  }
}
