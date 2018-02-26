import Foundation

public struct Message: Swift.Decodable {
  public let body: String
  public let createdAt: TimeInterval
  public let id: Int
  public let recipient: User
  public let sender: User
}

extension Message {
  enum CodingKeys: String, CodingKey {
    case body,
    createdAt = "created_at",
    id,
    recipient,
    sender
  }
//
//  public init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.body = try container.decode(String.self, forKey: .body)
//    self.createdAt = try container.decode(TimeInterval.self, forKey: .createdAt)
//    self.id = try container.decode(Int.self, forKey: .id)
//    self.recipient = try container.decode(User.self, forKey: .recipient)
//    self.sender = try container.decode(User.self, forKey: .sender)
//  }
}
