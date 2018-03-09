import Foundation

public struct ShippingRule: Swift.Decodable {
  public let cost: Double
  public let id: Int?
  public let location: Location
}

extension ShippingRule {
  enum CodingKeys: String, CodingKey {
    case cost, id, location
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let costString = try values.decode(String.self, forKey: .cost)
    self.cost = stringToDouble(costString)
    self.id = try? values.decode(Int.self, forKey: .id)
    self.location = try values.decode(Location.self, forKey: .location)
  }
}

extension ShippingRule: Equatable {}
public func == (lhs: ShippingRule, rhs: ShippingRule) -> Bool {
  // todo: change to compare id once that api is deployed
  return lhs.location ==  rhs.location
}

private func stringToDouble(_ string: String) -> Double {
  return Double(string) ?? 0
}
