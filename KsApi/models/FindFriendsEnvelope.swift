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

extension FindFriendsEnvelope {
  enum CodingKeys: String, CodingKey {
    case contactsImported = "contacts_imported",
    urls,
    users
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.contactsImported = try values.decode(Bool.self, forKey: .contactsImported)
    self.urls = try values.decode(UrlsEnvelope.self, forKey: .urls)
    self.users = try [values.decode(User.self, forKey: .users)] // this?
  }
}

extension FindFriendsEnvelope.UrlsEnvelope.ApiEnvelope {
  enum CodingKeys: String, CodingKey {
    case moreUsers = "more_users"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.moreUsers = try? values.decode(String.self, forKey: .moreUsers)
  }
}
