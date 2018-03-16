import Foundation
import Prelude

public struct Project: Swift.Decodable {

  public private(set) var blurb: String
  public private(set) var category: Category
  public private(set) var country: Country
  public private(set) var creator: User
  public private(set) var memberData: MemberData
  public private(set) var dates: Dates
  public private(set) var id: Int
  public private(set) var location: Location
  public private(set) var name: String
  public private(set) var personalization: Personalization
  public private(set) var photo: Photo
  public private(set) var rewards: [Reward]
  public private(set) var slug: String
  public private(set) var state: State
  public private(set) var stats: Stats
  public private(set) var urls: UrlsEnvelope
  public private(set) var video: Video?

  public struct UrlsEnvelope: Swift.Decodable {
    public let web: WebEnvelope

    public struct WebEnvelope: Swift.Decodable {
      public let project: String
      public let updates: String?
    }
  }

  public struct Video: Swift.Decodable {
    public let id: Int
    public let high: String
  }

  public enum State: String, Swift.Decodable {
    case canceled
    case failed
    case live
    case purged
    case started
    case submitted
    case successful
    case suspended
  }

  public struct Stats: Swift.Decodable {
    public let backersCount: Int
    public let commentsCount: Int?
    public let currentCurrency: String?
    public let currentCurrencyRate: Float?
    public let goal: Int
    public let pledged: Int
    public let staticUsdRate: Float
    public let updatesCount: Int?

    /// Percent funded as measured from `0.0` to `1.0`. See `percentFunded` for a value from `0` to `100`.
    public var fundingProgress: Float {
      return self.goal == 0 ? 0.0 : Float(self.pledged) / Float(self.goal)
    }

    /// Percent funded as measured from `0` to `100`. See `fundingProgress` for a value between `0.0`
    /// and `1.0`.
    public var percentFunded: Int {
      return Int(floor(self.fundingProgress * 100.0))
    }

    /// Pledged amount converted to USD.
    public var pledgedUsd: Int {
      return Int(floor(Float(self.pledged) * self.staticUsdRate))
    }

    /// Goal amount converted to USD.
    public var goalUsd: Int {
      return Int(floor(Float(self.goal) * self.staticUsdRate))
    }

    /// Pledged amount converted to current currency.
    public var pledgedCurrentCurrency: Int? {
      return self.currentCurrencyRate.map { Int(floor(Float(self.pledged) * $0)) }
    }

    /// Goal amount converted to current currency.
    public var goalCurrentCurrency: Int? {
      return self.currentCurrencyRate.map { Int(floor(Float(self.goal) * $0)) }
    }
  }

  public struct MemberData: Swift.Decodable {
    public let lastUpdatePublishedAt: TimeInterval?
    public let permissions: [Permission]
    public let unreadMessagesCount: Int?
    public let unseenActivityCount: Int?

    public enum Permission: String, Swift.Decodable {
      case editProject = "edit_project"
      case editFaq = "edit_faq"
      case post = "post"
      case comment = "comment"
      case viewPledges = "view_pledges"
      case fulfillment = "fulfillment"
      case unknown = "unknown"
    }
  }

  public struct Dates: Swift.Decodable {
    public let deadline: TimeInterval
    public let featuredAt: TimeInterval?
    public let launchedAt: TimeInterval
    public let stateChangedAt: TimeInterval
  }

  public struct Personalization: Swift.Decodable {
    public let backing: Backing?
    public let friends: [User]?
    public let isBacking: Bool?
    public let isStarred: Bool?
  }

  public struct Photo: Swift.Decodable {
    public let full: String
    public let med: String
    public let size1024x768: String?
    public let small: String
  }

  public func endsIn48Hours(today: Date = Date()) -> Bool {
    let twoDays: TimeInterval = 60.0 * 60.0 * 48.0
    return self.dates.deadline - today.timeIntervalSince1970 <= twoDays
  }

  public func isFeaturedToday(today: Date = Date(), calendar: Calendar = .current) -> Bool {
    guard let featuredAt = self.dates.featuredAt else { return false }
    return isDateToday(date: featuredAt, today: today, calendar: calendar)
  }

  private func isDateToday(date: TimeInterval, today: Date, calendar: Calendar) -> Bool {
    let startOfToday = calendar.startOfDay(for: today)
    return abs(startOfToday.timeIntervalSince1970 - date) < 60.0 * 60.0 * 24.0
  }
}

extension Project: Equatable {}
public func == (lhs: Project, rhs: Project) -> Bool {
  return lhs.id == rhs.id
}

extension Project: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "Project(id: \(self.id), name: \"\(self.name)\")"
  }
}

extension Project {
  enum CodingKeys: String, CodingKey {
    case blurb,
    category,
    country,
    creator,
    dates,
    id,
    location,
    memberData,
    name,
    personalization,
    photo,
    rewards,
    slug,
    state,
    stats,
    urls,
    video
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.blurb = try container.decode(String.self, forKey: .blurb)
    self.category = try container.decode(Category.self, forKey: .category)
    self.country = try Project.Country(from: decoder)
    self.creator = try container.decode(User.self, forKey: .creator)
    self.dates = try Project.Dates(from: decoder)
    self.id = try container.decode(Int.self, forKey: .id)

    do {
      self.location = try container.decode(Location.self, forKey: .location)
    } catch {
      self.location = .none
    }
    self.memberData = try Project.MemberData(from: decoder)
    self.name = try container.decode(String.self, forKey: .name)
    self.personalization = try Project.Personalization(from: decoder)
    self.photo = try container.decode(Project.Photo.self, forKey: .photo)
    do {
      self.rewards = try container.decode([Reward].self, forKey: .rewards)
    } catch {
      self.rewards = []
    }
    self.slug = try container.decode(String.self, forKey: .slug)

    let state = try container.decode(String.self, forKey: .state)
    self.state = Project.State(rawValue: state)!
    self.stats = try Project.Stats(from: decoder)
    self.urls = try container.decode(Project.UrlsEnvelope.self, forKey: .urls)
    self.video = try? container.decode(Project.Video.self, forKey: .video)
  }
}

extension Project.UrlsEnvelope {

  enum CodingKeys: String, CodingKey {
    case web
  }
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.web = try container.decode(WebEnvelope.self, forKey: .web)
  }
}

extension Project.UrlsEnvelope.WebEnvelope {

  enum CodingKeys: String, CodingKey {
    case project, updates
  }
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.project = try container.decode(String.self, forKey: .project)
    self.updates = try? container.decode(String.self, forKey: .updates)
  }
}


extension Project.MemberData {
  enum CodingKeys: String, CodingKey {
    case lastUpdatePublishedAt = "last_update_published_at",
    permissions,
    unreadMessagesCount = "unread_messages_count",
    unseenActivityCount = "unseen_activity_count"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.lastUpdatePublishedAt = try? container.decode(TimeInterval.self, forKey: .lastUpdatePublishedAt)
    let rawPermissions = try Project.MemberData.Permission(from: decoder)
    self.permissions = removeUnknowns([rawPermissions])
    self.unreadMessagesCount = try? container.decode(Int.self, forKey: .unreadMessagesCount)
    self.unseenActivityCount = try? container.decode(Int.self, forKey: .unseenActivityCount)
  }
}

extension Project.MemberData.Permission {
  enum CodingKeys: String, CodingKey {
    case permission
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      self = try container.decode(Project.MemberData.Permission.self, forKey: .permission)
    } catch {
      self = .unknown
    }
  }
}

extension Project.Stats {
  enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count",
    commentsCount = "comments_count",
    currentCurrency = "current_currency",
    currentCurrencyRate = "fx_rate",
    goal,
    pledged,
    staticUsdRate = "static_usd_rate",
    updatesCount = "updates_count"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backersCount = try container.decode(Int.self, forKey: .backersCount)
    self.commentsCount = try? container.decode(Int.self, forKey: .commentsCount)
    self.currentCurrency = try? container.decode(String.self, forKey: .currentCurrency)
    self.currentCurrencyRate = try? container.decode(Float.self, forKey: .currentCurrencyRate)
    self.goal = try container.decode(Int.self, forKey: .goal)
    let pledgedFloat = try Int(container.decode(Float.self, forKey: .pledged))
    self.pledged = Int(pledgedFloat)

    do {
      self.staticUsdRate = try container.decode(Float.self, forKey: .staticUsdRate)
    } catch {
      self.staticUsdRate = 1.0
    }

    self.updatesCount = try? container.decode(Int.self, forKey: .updatesCount)
  }
}

extension Project.Dates {
  enum CodingKeys: String, CodingKey {
    case deadline,
    featuredAt = "featured_at",
    launchedAt = "launched_at",
    stateChangedAt = "state_changed_at"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.deadline = try container.decode(TimeInterval.self, forKey: .deadline)
    self.featuredAt = try? container.decode(TimeInterval.self, forKey: .featuredAt)
    self.launchedAt = try container.decode(TimeInterval.self, forKey: .launchedAt)
    self.stateChangedAt = try container.decode(TimeInterval.self, forKey: .stateChangedAt)
  }
}

extension Project.Personalization {
  enum CodingKeys: String, CodingKey {
    case backing,
    friends,
    isBacking = "is_backing",
    isStarred = "is_starred"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backing = try? container.decode(Backing.self, forKey: .backing)
    self.friends = try? container.decode([User].self, forKey: .friends)
    self.isBacking = try? container.decode(Bool.self, forKey: .isBacking)
    self.isStarred = try? container.decode(Bool.self, forKey: .isStarred)
  }
}

extension Project.Photo {
  enum CodingKeys: String, CodingKey {
    case full,
    med,
    size1024x768 = "1024x768",
    size1024x576 = "1024x576",
    small
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.full = try container.decode(String.self, forKey: .full)
    self.med = try container.decode(String.self, forKey: .med)

    if let value =  try? container.decode(String.self, forKey: .size1024x768) {
      self.size1024x768 = value
    } else {
      self.size1024x768 = try? container.decode(String.self, forKey: .size1024x576)
    }

    self.small = try container.decode(String.self, forKey: .small)
  }
}

private func removeUnknowns(_ xs: [Project.MemberData.Permission]) -> [Project.MemberData.Permission] {
  return xs.filter { $0 != .unknown }
}

private func toInt(string: String) -> Int {
  return Int(string) ?? -1
}

/*
 This is a helper function that extracts the value from the Argo.JSON object type to create a graph Category
 object (that conforms to Swift.Decodable). It's an work around that fixes the problem of incompatibility
 between Swift.Decodable and Argo.Decodable protocols and will be deleted in the future when we update our
 code to use exclusively Swift's native Decodable.
 */
//private func decodeToGraphCategory(_ json: JSON?) -> Decoded<Category> {
//
//  guard let jsonObj = json else {
//    return .success(Category(id: "-1", name: "Unknown Category"))
//  }
//
//  switch jsonObj {
//  case .object(let dic):
//    let category = Category(id: categoryInfo(dic).0,
//                            name: categoryInfo(dic).1,
//                            parentId: categoryInfo(dic).2)
//    return .success(category)
//  default:
//    return .failure(DecodeError.custom("JSON should be object type"))
//  }
//}
//
//private func categoryInfo(_ json: [String: JSON]) -> (String, String, String?) {
//
//  guard let name = json["name"], let id = json["id"] else {
//    return("", "", nil)
//  }
//  let parentId = json["parent_id"]
//
//  switch (id, name, parentId) {
//  case (.number(let id), .string(let name), .number(let parentId)?):
//    return ("\(id)", name, "\(parentId)")
//  case (.number(let id), .string(let name), nil):
//    return ("\(id)", name, nil)
//  default:
//    return("", "", nil)
//  }
//}

