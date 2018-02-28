import Foundation

public struct FindFriendsEnvelope: Swift.Decodable {
  public let contactsImported: Bool
  public let urls: UrlsEnvelope
  public let users: [User]

  public struct UrlsEnvelope: Swift.Decodable {
    public let api: ApiEnvelope

    public struct ApiEnvelope: Swift.Decodable {
      public let moreUsers: String?
    }
  }
}

extension FindFriendsEnvelope.UrlsEnvelope {
  enum CodingKeys: String, CodingKey {
    case api
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.api = try container.decode(ApiEnvelope.self, forKey: .api)
  }
}

extension FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope {
  enum CodingKeys: String, CodingKey {
    case moreUsers = "more_users"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.moreUsers = try? container.decode(String.self, forKey: .moreUsers)
  }
}

extension FindFriendsEnvelope {
  enum CodingKeys: String, CodingKey {
    case contactsImported = "contacts_imported",
    urls,
    users
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.contactsImported = try container.decode(Bool.self, forKey: .contactsImported)
    self.urls = try container.decode(FindFriendsEnvelope.UrlsEnvelope.self, forKey: .urls)
    self.users = try container.decode([User].self, forKey: .users)
  }
}

