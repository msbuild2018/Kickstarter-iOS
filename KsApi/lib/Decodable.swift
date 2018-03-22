import Foundation
import Prelude

public extension Swift.Decodable {
  /**
   Decode a JSON dictionary into a `Decoded` type.

   - parameter json: A dictionary with string keys.

   - returns: A decoded value.
   */
  public static func decodeJSONDictionary<M: Swift.Decodable>(_ json: [String: AnyHashable]) -> M? {
    guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
      return nil
    }
    do {
      let object = try JSONDecoder().decode(M.self, from: data)
      return object as M
    } catch {
      return nil
    }
  }
}
