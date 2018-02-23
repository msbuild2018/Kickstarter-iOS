import Argo

public func decodableToDecoded<T: Swift.Decodable>(_ json: JSON?) -> Decoded<T> {
  guard let json = json else {
    return .failure(.custom("JSON should not be nil"))
  }

  return genericDecodableToDecoded(json)
}

public func decodableToDecoded<T: Swift.Decodable>(_ json: JSON?) -> Decoded<[T]> {
  guard let json = json else {
    return .failure(.custom("JSON should not be nil"))
  }

  return genericDecodableToDecoded(json)
}

public func decodableToDecoded<T: Swift.Decodable>(_ json: JSON?) -> Decoded<T>? {
  guard let json = json else {
    return nil
  }

  return genericDecodableToDecoded(json)
}

public func genericDecodableToDecoded<T: Swift.Decodable>(_ json: JSON) -> Decoded<T> {
  let dict = encode(json) as! NSDictionary
  print(dict.allKeys)

  do {
    let json = try JSONSerialization.data(withJSONObject: dict, options: [])
    let decoded = try JSONDecoder().decode(T.self, from: json)

    return .success(decoded)
  }
  catch (let error) {
    return .failure(.custom("Failed to decode \(T.self), \(error.localizedDescription)"))
  }
}

public func encode(_ json: JSON) -> Any {
  switch json {
  case .null: return NSNull()
  case let .bool(v): return v
  case let .string(v): return v
  case let .number(v): return v
  case let .array(a): return a.map(encode)
  case let .object(v):
    var object: [String: Any] = [:]
    for key in v.keys {
      if let value: JSON = v[key] {
        object[key] = encode(value)
      } else {
        object[key] = NSNull()
      }
    }
    return object
  }
}
