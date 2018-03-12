import Foundation
import Prelude

internal protocol FirebaseDataSnapshotType {
  var key: String { get }
  var value: Any? { get }
}

// FIXME: Implement decode funtion
// Returns an empty array if any snapshot decodings fail
internal extension Collection where Iterator.Element == LiveStreamChatMessage {
  static func decode(_ snapshots: [FirebaseDataSnapshotType]) -> [LiveStreamChatMessage] {
    return snapshots.flatMap { snapshot in
      LiveStreamChatMessage.decode(snapshot)
    }
  }

}

public struct LiveStreamChatMessage: Swift.Decodable {
  public fileprivate(set) var date: TimeInterval
  public fileprivate(set) var id: String
  public fileprivate(set) var isCreator: Bool?
  public fileprivate(set) var message: String
  public fileprivate(set) var name: String
  public fileprivate(set) var profilePictureUrl: String
  public fileprivate(set) var userId: String

  static internal func decode(_ snapshot: FirebaseDataSnapshotType) -> LiveStreamChatMessage {
    return LiveStreamChatMessage.init(date: 0,
                                      id: "",
                                      isCreator: nil,
                                      message: "",
                                      name: "",
                                      profilePictureUrl: "",
                                      userId: "")//(snapshot.value as? [String: Any])
  }
}

extension LiveStreamChatMessage {
  enum CodingKeys: String, CodingKey {
    case date = "timestamp",
    id,
    isCreator = "creator",
    message,
    name,
    profilePictureUrl = "profilePic",
    userId
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.date = try values.decode(TimeInterval.self, forKey: .date)
    self.id = try values.decode(String.self, forKey: .id)
    self.isCreator = try? values.decode(Bool.self, forKey: .isCreator)
    self.message = try values.decode(String.self, forKey: .message)
    self.name = try values.decode(String.self, forKey: .name)
    self.profilePictureUrl = try values.decode(String.self, forKey: .profilePictureUrl)
    self.userId = try values.decode(String.self, forKey: .userId)
  }
}

extension LiveStreamChatMessage: Equatable {
  static public func == (lhs: LiveStreamChatMessage, rhs: LiveStreamChatMessage) -> Bool {
    return lhs.id == rhs.id
  }
}

extension LiveStreamChatMessage {
  public enum lens {
    public static let id = Lens<LiveStreamChatMessage, String>(
      view: { $0.id },
      set: { var new = $1; new.id = $0; return new }
    )
    public static let isCreator = Lens<LiveStreamChatMessage, Bool?>(
      view: { $0.isCreator },
      set: { var new = $1; new.isCreator = $0; return new }
    )
    public static let message = Lens<LiveStreamChatMessage, String>(
      view: { $0.message },
      set: { var new = $1; new.message = $0; return new }
    )
    public static let name = Lens<LiveStreamChatMessage, String>(
      view: { $0.name },
      set: { var new = $1; new.name = $0; return new }
    )
    public static let profilePictureUrl = Lens<LiveStreamChatMessage, String>(
      view: { $0.profilePictureUrl },
      set: { var new = $1; new.profilePictureUrl = $0; return new }
    )
    public static let date = Lens<LiveStreamChatMessage, TimeInterval>(
      view: { $0.date },
      set: { var new = $1; new.date = $0; return new }
    )
    public static let userId = Lens<LiveStreamChatMessage, String>(
      view: { $0.userId },
      set: { var new = $1; new.userId = $0; return new }
    )
  }
}
