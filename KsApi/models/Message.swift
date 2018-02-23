import Argo
import Curry
import Runes
import Foundation

public struct Message: Swift.Decodable {
  public let body: String
  public let createdAt: TimeInterval
  public let id: Int
  public let recipient: User
  public let sender: User

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.body = try container.decode(String.self, forKey: .body)
    self.createdAt = try container.decode(TimeInterval.self, forKey: .createdAt)
    self.id = try container.decode(Int.self, forKey: .id)

    let recipientDict = try container.decode([String: Any].self, forKey: .recipient)
    guard let recipient = User.decodeJSONDictionary(recipientDict).value else {
      throw DecodingError.dataCorruptedError(
        forKey: .recipient,
        in: container,
        debugDescription: "Could not decode recipient"
      )
    }

    self.recipient = recipient

    let senderDict = try container.decode([String: Any].self, forKey: .sender)
    guard let sender = User.decodeJSONDictionary(senderDict).value else {
      throw DecodingError.dataCorruptedError(
        forKey: .sender,
        in: container,
        debugDescription: "Could not decode sender"
      )
    }

    self.sender = sender
  }

  init(body: String, createdAt: TimeInterval, id: Int, recipient: User, sender: User) {
    self.body = body
    self.createdAt = createdAt
    self.id = id
    self.recipient = recipient
    self.sender = sender
  }

  private enum CodingKeys: String, CodingKey {
    case body
    case createdAt = "created_at"
    case id
    case recipient
    case sender
  }
}

//extension Message: Argo.Decodable {
//  public static func decode(_ json: JSON) -> Decoded<Message> {
//    return curry(Message.init)
//      <^> json <| "body"
//      <*> json <| "created_at"
//      <*> json <| "id"
//      <*> json <| "recipient"
//      <*> json <| "sender"
//  }
//}

