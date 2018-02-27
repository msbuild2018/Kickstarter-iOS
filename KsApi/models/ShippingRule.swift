import Foundation

public struct ShippingRule: Swift.Decodable {
  public let cost: Double
  public let id: Int?
  public let location: Location
}

extension ShippingRule: Equatable {}
public func == (lhs: ShippingRule, rhs: ShippingRule) -> Bool {
  // todo: change to compare id once that api is deployed
  return lhs.location ==  rhs.location
}

private func stringToDouble(_ string: String) -> Decoded<Double> {
  return Double(string).map(Decoded.success) ?? .success(0)
}
