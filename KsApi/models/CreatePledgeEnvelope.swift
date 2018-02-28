import Foundation

public struct CreatePledgeEnvelope: Swift.Decodable {
  public let checkoutUrl: String?
  public let newCheckoutUrl: String?
  public let status: Int

  public struct EnvelopeData: Swift.Decodable {
    let checkoutUrl: String?
    let newCheckoutUrl: String?
  }
}

extension CreatePledgeEnvelope {
  enum CodingKeys: String, CodingKey {
    case checkoutUrl = "checkout_url",
    data,
    newCheckoutUrl = "new_checkout_url",
    status
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let data = try? container.decode(CreatePledgeEnvelope.EnvelopeData.self, forKey: .data)
    self.checkoutUrl = data?.checkoutUrl
    self.newCheckoutUrl = data?.newCheckoutUrl
    self.status = try container.decode(Int.self, forKey: .status)
  }
}
