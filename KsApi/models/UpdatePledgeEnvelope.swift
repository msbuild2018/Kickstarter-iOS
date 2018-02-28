import Foundation

public struct UpdatePledgeEnvelope: Swift.Decodable {
  public let newCheckoutUrl: String?
  public let status: Int

  struct UpdatePledgeEnvelopeData: Swift.Decodable {
    let newCheckoutUrl: String
  }
}

extension UpdatePledgeEnvelope.UpdatePledgeEnvelopeData {
  enum CodingKeys: String, CodingKey {
    case newCheckoutUrl = "new_checkout_url"
  }
}

extension UpdatePledgeEnvelope {
  enum CodingKeys: String, CodingKey {
    case data,
    status
  }
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.newCheckoutUrl = try? container.decode(UpdatePledgeEnvelopeData.self, forKey: .data).newCheckoutUrl
    let statusString = try container.decode(String.self, forKey: .status)
    self.status = stringToIntOrZero(statusString)
  }
}

private func stringToIntOrZero(_ string: String) -> Int {
  return
    Double(string).flatMap(Int.init) ?? Int(string) ?? 0
}
