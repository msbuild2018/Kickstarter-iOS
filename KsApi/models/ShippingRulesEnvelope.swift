import Foundation

public struct ShippingRulesEnvelope: Swift.Decodable {
  public let shippingRules: [ShippingRule]
}

extension ShippingRulesEnvelope {
  enum CodingKeys: String, CodingKey {
    case shippingRules = "shipping_rules"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.shippingRules = try container.decode([ShippingRule].self, forKey: .shippingRules)
  }
}
