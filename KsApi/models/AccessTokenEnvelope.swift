import Foundation

public struct AccessTokenEnvelope: Swift.Decodable {
  public let accessToken: String
  public let user: User
}

extension AccessTokenEnvelope {
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token",
    user
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.user = try container.decode(User.self, forKey: .user)
  }
}
