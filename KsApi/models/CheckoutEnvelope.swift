import Foundation

public struct CheckoutEnvelope: Swift.Decodable {
  public enum State: String, Swift.Decodable {
    case authorizing
    case failed
    case successful
    case verifying
  }
  public let state: State
  public let stateReason: String
}

extension CheckoutEnvelope {
  enum CodingKeys: String, CodingKey {
    case state,
    stateReason = "state_reason"
  }

public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.state = try values.decode(State.self, forKey: .state)
    self.stateReason = try values.decode(String.self, forKey: .stateReason)
  }
}
