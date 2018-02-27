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

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.backing = try? values.decode(Backing.self, forKey: .backing)
    self.closed = try values.decode(Bool.self, forKey: .closed)
    self.id = try values.decode(Int.self, forKey: .id)
    self.lastMessage = try values.decode(Message.self, forKey: .lastMessage)
    self.participant = try values.decode(User.self, forKey: .participant)
    self.project = try values.decode(Project.self, forKey: .project)
    self.unreadMessagesCount = try values.decode(Int.self, forKey: .unreadMessagesCount)
  }
}

extension MessageThread: Equatable {}
public func == (lhs: MessageThread, rhs: MessageThread) -> Bool {
  return lhs.id == rhs.id
}
