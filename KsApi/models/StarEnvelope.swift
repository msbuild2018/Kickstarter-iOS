import Foundation

public struct StarEnvelope: Swift.Decodable {
  public let user: User
  public let project: Project
}

extension StarEnvelope {
  enum CodingKeys: String, CodingKey {
    case user, project
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.user = try values.decode(User.self, forKey: .user)
    self.project = try values.decode(Project.self, forKey: .project)
  }
}
