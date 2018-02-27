import Foundation

public struct AccessTokenEnvelope: Swift.Decodable {
  public let accessToken: String
  public let user: User
}

extension AccessTokenEnvelope {
  enum CodingKeys: String, CodingKey {
    case accessToken = "accessToken",
    user
  }
}
