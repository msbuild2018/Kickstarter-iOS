import Argo
import Curry
import Runes

public struct MessageThreadEnvelope {
  public let participants: [User]
  public let messages: [Message]
  public let messageThread: MessageThread
}

extension MessageThreadEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<MessageThreadEnvelope> {
    return curry(MessageThreadEnvelope.init)
      <^> json <|| "participants"
      <*> ((json <|| "messages" >>- testFunc) as Decoded<[Message]>)
      <*> json <| "message_thread"
  }
}

func testFunc(_ json: Any) -> Decoded<[Message]> {
  return .success([Message.template])
}
