import Argo
import Foundation
import Prelude

public extension Swift.Decodable {
  /**
   Decode a JSON dictionary into a generic `M` type.

   - parameter json: A dictionary with string keys.

   - returns: A M (Swift Decodable) value.
   */
  public static func decodeJSONDictionary<M: Swift.Decodable>(_ json: [String: Any]) -> M? {
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

public extension Argo.Decodable {
  /**
   Decode a JSON dictionary into a `Decoded` type.

   - parameter json: A dictionary with string keys.

   - returns: A decoded value.
   */
  public static func decodeJSONDictionary(_ json: [String: Any]) -> Decoded<DecodedType> {
    return Self.decode(JSON(json))
  }
}


