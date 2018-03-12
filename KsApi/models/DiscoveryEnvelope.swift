import Foundation

public struct DiscoveryEnvelope: Swift.Decodable {
  public let projects: [Project]
  public let urls: UrlsEnvelope
  public let stats: StatsEnvelope

  public struct UrlsEnvelope: Swift.Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope: Swift.Decodable {
      public let moreProjects: String

      public init(more_projects: String) {
        moreProjects = more_projects
      }
    }
  }

  public struct StatsEnvelope: Swift.Decodable {
    public let count: Int
  }
}

// needed?
extension DiscoveryEnvelope {
  enum CodingKeys: String, CodingKey {
    case projects, urls, stats
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.projects = try values.decode([Project].self, forKey: .projects)
    self.urls = try values.decode(UrlsEnvelope.self, forKey: .urls)
    self.stats = try values.decode(StatsEnvelope.self, forKey: .stats)
  }
}

extension DiscoveryEnvelope.UrlsEnvelope {
  enum CodingKeys: String, CodingKey {
    case api
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.api = try values.decode(ApiEnvelope.self, forKey: .api)
  }
}

extension DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope {
  enum CodingKeys: String, CodingKey {
    case moreProjects = "more_projects"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.moreProjects = try values.decode(String.self, forKey: .moreProjects)
  }
}
