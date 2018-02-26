import Foundation

public struct Item: Swift.Decodable {
  public let description: String?
  public let id: Int
  public let name: String
  public let projectId: Int
}

extension Item {
  enum CodingKeys: String, CodingKey {
    case description,
    id,
    name,
    projectId = "project_id"
  }
}
