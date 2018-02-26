import Foundation

public struct MessageThread: Swift.Decodable {
  public let backing: Backing?
  public let closed: Bool
  public let id: Int
  public let lastMessage: Message
  public let participant: User
  public let project: Project
  public let unreadMessagesCount: Int
}

extension MessageThread {
  enum CodingKeys: String, CodingKey {
    case backing,
    closed,
    id,
    lastMessage = "last_message",
    participant,
    project,
    unreadMessagesCount = "unread_messages_count"
  }
}

extension MessageThread: Equatable {}
public func == (lhs: MessageThread, rhs: MessageThread) -> Bool {
  return lhs.id == rhs.id
}
