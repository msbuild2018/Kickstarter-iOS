import Foundation
import Prelude

public struct DiscoveryParams: Swift.Decodable {

  public private(set) var backed: Bool?
  public private(set) var category: Category?
  public private(set) var collaborated: Bool?
  public private(set) var created: Bool?
  public private(set) var hasLiveStreams: Bool?
  public private(set) var hasVideo: Bool?
  public private(set) var includePOTD: Bool?
  public private(set) var page: Int?
  public private(set) var perPage: Int?
  public private(set) var query: String?
  public private(set) var recommended: Bool?
  public private(set) var seed: Int?
  public private(set) var similarTo: Project?
  public private(set) var social: Bool?
  public private(set) var sort: Sort?
  public private(set) var staffPicks: Bool?
  public private(set) var starred: Bool?
  public private(set) var state: State?

  public enum State: String, Swift.Decodable {
    case all
    case live
    case successful
  }

  public enum Sort: String, Swift.Decodable {
    case endingSoon = "end_date"
    case magic
    case mostFunded = "most_funded"
    case newest
    case popular = "popularity"
  }

  public static let defaults = DiscoveryParams(backed: nil, category: nil,
                                               collaborated: nil, created: nil,
                                               hasLiveStreams: nil, hasVideo: nil, includePOTD: nil,
                                               page: nil, perPage: nil, query: nil, recommended: nil,
                                               seed: nil, similarTo: nil, social: nil, sort: nil,
                                               staffPicks: nil, starred: nil, state: nil)

  public var queryParams: [String: String] {
    var params: [String: String] = [:]
    params["backed"] = self.backed == true ? "1" : self.backed == false ? "-1" : nil
    params["category_id"] = self.category?.intID?.description
    params["collaborated"] = self.collaborated?.description
    params["created"] = self.created?.description
    params["has_live_streams"] = self.hasLiveStreams?.description
    params["has_video"] = self.hasVideo?.description
    params["page"] = self.page?.description
    params["per_page"] = self.perPage?.description
    params["recommended"] = self.recommended?.description
    params["seed"] = self.seed?.description
    params["similar_to"] = self.similarTo?.id.description
    params["social"] = self.social == true ? "1" : self.social == false ? "-1" : nil
    params["sort"] = self.sort?.rawValue
    params["staff_picks"] = self.staffPicks?.description
    params["starred"] = self.starred == true ? "1" : self.starred == false ? "-1" : nil
    params["state"] = self.state?.rawValue
    params["term"] = self.query

    return params
  }
}

extension DiscoveryParams: Equatable {}
public func == (a: DiscoveryParams, b: DiscoveryParams) -> Bool {
  return a.queryParams == b.queryParams
}

extension DiscoveryParams: Hashable {
  public var hashValue: Int {
    return self.description.hash
  }
}

extension DiscoveryParams: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return self.queryParams.description
  }

  public var debugDescription: String {
    return self.queryParams.debugDescription
  }
}

extension DiscoveryParams {
  enum CodingKeys: String, CodingKey {
    case backed,
    category,
    collaborated,
    created,
    hasLiveStreams = "has_live_streams",
    hasVideo = "has_video",
    includePOTD = "include_potd",
    page,
    perPage = "per_page",
    query = "term",
    recommended,
    seed,
    similarTo = "similar_to",
    social,
    sort,
    staffPicks = "staff_picks",
    starred,
    state
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let backedString = try? container.decode(String.self, forKey: .backed)
    self.backed = stringIntToBool(backedString)
    self.category = try? container.decode(Category.self, forKey: .category)
    let collaboratedString = try? container.decode(String.self, forKey: .collaborated)
    self.collaborated = stringToBool(collaboratedString)
    let createdString = try? container.decode(String.self, forKey: .created)
    self.created = stringToBool(createdString)
    self.hasLiveStreams = try? container.decode(Bool.self, forKey: .hasLiveStreams)
    let hasVideoString = try? container.decode(String.self, forKey: .hasVideo)
    self.hasVideo = stringToBool(hasVideoString)
    let includePOTDString = try? container.decode(String.self, forKey: .includePOTD)
    self.includePOTD = stringToBool(includePOTDString)
    let pageString = try? container.decode(String.self, forKey: .page)
    self.page = stringToInt(pageString)
    let perPageString = try? container.decode(String.self, forKey: .perPage)
    self.perPage = stringToInt(perPageString)
    self.query = try? container.decode(String.self, forKey: .query)
    let recommendedString = try? container.decode(String.self, forKey: .recommended)
    self.recommended = stringToBool(recommendedString)
    let seedString = try? container.decode(String.self, forKey: .seed)
    self.seed = stringToInt(seedString)
    self.similarTo = try? container.decode(Project.self, forKey: .similarTo)
    let socialString = try? container.decode(String.self, forKey: .social)
    self.social = stringIntToBool(socialString)
    self.sort = try? container.decode(DiscoveryParams.Sort.self, forKey: .sort)
    let staffPicksString = try? container.decode(String.self, forKey: .staffPicks)
    self.staffPicks = stringToBool(staffPicksString)
    let starredString = try? container.decode(String.self, forKey: .starred)
    self.starred = stringIntToBool(starredString)
    self.state = try? container.decode(DiscoveryParams.State.self, forKey: .state)
  }
}

private func stringToBool(_ string: String?) -> Bool? {
  guard let string = string else { return nil }
  switch string {
  // taken from server's `value_to_boolean` function
  case "true", "1", "t", "T", "true", "TRUE", "on", "ON":
    return true
  case "false", "0", "f", "F", "false", "FALSE", "off", "OFF":
    return false
  default:
    return nil //"Could not parse string into bool."
  }
}

private func stringToInt(_ string: String?) -> Int? {
  guard let string = string else { return nil }
  return Int(string)
}

private func stringIntToBool(_ string: String?) -> Bool? {
  guard let string = string else { return nil }
  return Int(string)
    .filter { $0 <= 1 && $0 >= -1 }
    .map { ($0 == 0 ? nil : $0 == 1) } ?? false
}
