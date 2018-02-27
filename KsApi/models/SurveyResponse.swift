import Foundation

public struct SurveyResponse: Swift.Decodable {
  public let answeredAt: TimeInterval?
  public let id: Int
  public let project: Project?
  public let urls: UrlsEnvelope

  public struct UrlsEnvelope: Swift.Decodable {
    public let web: WebEnvelope

    public struct WebEnvelope: Swift.Decodable {
      public let survey: String
    }
  }
}

extension SurveyResponse: Equatable {}
public func == (lhs: SurveyResponse, rhs: SurveyResponse) -> Bool {
  return lhs.id == rhs.id
}

extension SurveyResponse {
  enum CodingKeys: String, CodingKey {
    case answeredAt = "answered_at",
    id,
    project,
    urls
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.answeredAt = try? values.decode(TimeInterval.self, forKey: .answeredAt)
    self.id = try values.decode(Int.self, forKey: .id)
    self.project = try values.decode(Project.self, forKey: .project)
    self.urls = try values.decode(UrlsEnvelope.self, forKey: .urls)
  }
}

