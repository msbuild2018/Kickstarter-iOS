import Foundation
import Prelude

public struct LiveStreamEvent: Swift.Decodable, Equatable {
  public fileprivate(set) var backgroundImage: BackgroundImage
  public fileprivate(set) var creator: Creator
  public fileprivate(set) var description: String
  public fileprivate(set) var firebase: Firebase?
  public fileprivate(set) var hasReplay: Bool
  public fileprivate(set) var hlsUrl: String?
  public fileprivate(set) var id: Int
  public fileprivate(set) var isRtmp: Bool?
  public fileprivate(set) var isScale: Bool?
  public fileprivate(set) var liveNow: Bool
  public fileprivate(set) var maxOpenTokViewers: Int?
  public fileprivate(set) var name: String
  public fileprivate(set) var openTok: OpenTok?
  public fileprivate(set) var project: Project
  public fileprivate(set) var replayUrl: String?
  public fileprivate(set) var startDate: Date
  public fileprivate(set) var stream: Stream
  public fileprivate(set) var user: User?
  public fileprivate(set) var webUrl: String
  public fileprivate(set) var numberPeopleWatching: Int?

  public struct Stream: Swift.Decodable {
    let backgroundImage: BackgroundImage
    let description: String
    let hasReplay: Bool
    let hlsUrl: String?
    let isRtmp: Bool?
    let isScale: Bool?
    let liveNow: Bool
    let maxOpenTokViewers: Int?
    let name: String
    let replayUrl: String?
    let startDate: Date
    let webUrl: String
  }

  public struct BackgroundImage: Swift.Decodable {
    public fileprivate(set) var medium: String
    public fileprivate(set) var smallCropped: String
  }

  public struct Creator: Swift.Decodable {
    public fileprivate(set) var avatar: String
    public fileprivate(set) var name: String
  }

  public struct Firebase: Swift.Decodable {
    public fileprivate(set) var apiKey: String
    public fileprivate(set) var chatAvatarUrl: String?
    public fileprivate(set) var chatPath: String
    public fileprivate(set) var chatPostPath: String?
    public fileprivate(set) var chatUserId: String?
    public fileprivate(set) var chatUserName: String?
    public fileprivate(set) var greenRoomPath: String
    public fileprivate(set) var hlsUrlPath: String
    public fileprivate(set) var numberPeopleWatchingPath: String
    public fileprivate(set) var project: String
    public fileprivate(set) var scaleNumberPeopleWatchingPath: String
    public fileprivate(set) var token: String?
  }

  public struct OpenTok: Swift.Decodable {
    public fileprivate(set) var appId: String
    public fileprivate(set) var sessionId: String
    public fileprivate(set) var token: String
  }

  public struct Project: Swift.Decodable {
    public fileprivate(set) var id: Int?
    public fileprivate(set) var name: String
    public fileprivate(set) var webUrl: String
  }

  public struct User: Swift.Decodable {
    public fileprivate(set) var isSubscribed: Bool
  }

  // Useful for safeguarding against getting a `hasReplay == true` yet the `replayUrl` is `nil`.
  public var definitelyHasReplay: Bool {
    return self.hasReplay && self.replayUrl != nil
  }

  public static func canonicalLiveStreamEventComparator(now: Date) -> Prelude.Comparator<LiveStreamEvent> {

    // Compares two live streams, putting live ones first.
    let currentlyLiveStreamsFirstComparator = Prelude.Comparator<LiveStreamEvent> { lhs, rhs in
      switch (lhs.liveNow, rhs.liveNow) {
      case (true, false):                 return .lt
      case (false, true):                 return .gt
      case (true, true), (false, false):  return .eq
      }
    }

    // Compares two live streams, putting the future ones first.
    let futureLiveStreamsFirstComparator = Prelude.Comparator<LiveStreamEvent> { lhs, rhs in
      lhs.startDate > now && rhs.startDate > now || lhs.startDate < now && rhs.startDate < now
        ? .eq : lhs.startDate < rhs.startDate ? .gt
        : .lt
    }

    // Compares two live streams, putting soon-to-be-live first and way-back past last.
    let startDateComparator = Prelude.Comparator<LiveStreamEvent> { lhs, rhs in
      lhs.startDate > now
        ? (lhs.startDate == rhs.startDate ? .eq : lhs.startDate < rhs.startDate ? .lt: .gt)
        : (lhs.startDate == rhs.startDate ? .eq : lhs.startDate < rhs.startDate ? .gt: .lt)
    }

    // Sort by:
    //   * live streams first
    //   * then future streams first and past streams last
    //   * future streams sorted by start date asc, past streams sorted by start date desc
    return currentlyLiveStreamsFirstComparator
      <> futureLiveStreamsFirstComparator
      <> startDateComparator
  }
}

public func == (lhs: LiveStreamEvent, rhs: LiveStreamEvent) -> Bool {
  return lhs.id == rhs.id
}

extension LiveStreamEvent.Stream {
  enum CodingKeys: String, CodingKey {
    case backgroundImage = "background_image", description, hasReplay = "has_replay", hlsUrl = "hls_url",
    isRtmp = "is_rtmp", isScale = "is_scale", liveNow = "live_now",
    maxOpenTokViewers = "max_opentok_viewers", name, replayUrl = "replay_url", startDate = "start_date",
    webUrl = "web_url"
  }
}

extension LiveStreamEvent {
  enum CodingKeys: String, CodingKey {
    case hlsUrl = "hls_url", backgroundImage = "background_image", creator, description, firebase,
    hasReplay = "has_replay", id, liveNow = "live_now", name, opentok, project, startDate = "start_date",
    stream, user, webUrl = "web_url", numberPeopleWatching = "number_people_watching"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    do {
      self.backgroundImage = try values.decode(BackgroundImage.self, forKey: .backgroundImage)
    } catch {
      self.backgroundImage = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).backgroundImage
    }

    self.creator = try values.decode(Creator.self, forKey: .creator)

    do {
      self.description = try values.decode(String.self, forKey: .description)
    } catch {
      self.description = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).description
    }

    self.firebase = try? values.decode(Firebase.self, forKey: .firebase)

    do {
      self.hasReplay = try values.decode(Bool.self, forKey: .hasReplay)
    } catch {
      self.hasReplay = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).hasReplay
    }

    do {
      self.hlsUrl = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).hlsUrl
    } catch {
      self.hlsUrl = try values.decode(String.self, forKey: .hlsUrl)
    }

    self.id = try values.decode(Int.self, forKey: .id)
    self.isRtmp = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).isRtmp
    self.isScale = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).isScale

    do {
      self.liveNow = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).liveNow
    } catch {
      self.liveNow = try values.decode(Bool.self, forKey: .liveNow)
    }

    self.maxOpenTokViewers = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).maxOpenTokViewers

    do {
      self.name = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).name
    } catch {
      self.name = try values.decode(String.self, forKey: .name)
    }

    self.openTok = try values.decode(LiveStreamEvent.OpenTok.self, forKey: .opentok)

    do {
      self.stream = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream)
    } catch {
      self.project = try values.decode(Project.self, forKey: .project)
    }

    self.replayUrl = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).replayUrl

    do {
      self.startDate = try values.decode(Date.self, forKey: .startDate)
    } catch {
      self.startDate = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).startDate
    }

    self.user = try? values.decode(User.self, forKey: .user)

    do {
      self.webUrl = try values.decode(LiveStreamEvent.Stream.self, forKey: .stream).webUrl
    } catch {
      self.webUrl = try values.decode(String.self, forKey: .webUrl)
    }

    self.numberPeopleWatching = try? values.decode(Int.self, forKey: .numberPeopleWatching)
  }

//  static public func decode(_ json: JSON) -> Decoded<LiveStreamEvent> {
//
//    let hlsUrl: Decoded<String?> = (json <| ["stream", "hls_url"] <|> json <| "hls_url")
//      .map(Optional.some)
//      <|> .success(nil)
//
//    let tmp1 = curry(LiveStreamEvent.init)
//      <^> (json <| ["stream", "background_image"] <|> json <| "background_image")
//      <*> json <| "creator"
//      <*> (json <| ["stream", "description"] <|> json <| "description")
//      <*> json <|? "firebase"
//    let tmp2 = tmp1
//      <*> (json <| ["stream", "has_replay"] <|> json <| "has_replay")
//      <*> hlsUrl
//      <*> json <| "id"
//      <*> json <|? ["stream", "is_rtmp"]
//    let tmp3 = tmp2
//      <*> json <|? ["stream", "is_scale"]
//      <*> (json <| ["stream", "live_now"] <|> json <| "live_now")
//      <*> json <|? ["stream", "max_opentok_viewers"]
//      <*> (json <| ["stream", "name"] <|> json <| "name")
//    let tmp4 = tmp3
//      <*> json <|? "opentok"
//      // Sometimes the project data is included in a `stream` sub-key, and sometimes it's in a `project`.
//      <*> (json <| "stream" <|> json <| "project")
//      <*> json <|? ["stream", "replay_url"]
//      <*> ((json <| "start_date" <|> json <| ["stream", "start_date"]) >>- toDate) /// WHAT DOES THIS MEAN?
//    return tmp4
//      <*> json <|? "user"
//      <*> (json <| ["stream", "web_url"] <|> json <| "web_url")
//      <*> json <|? "number_people_watching"
//  }
}

extension LiveStreamEvent.BackgroundImage {
  enum CodingKeys: String, CodingKey {
    case medium,
    smallCropped = "small_cropped"
  }
}

extension LiveStreamEvent.Creator {
  enum CodingKeys: String, CodingKey {
    case avatar = "creator_avatar",
    name = "creator_name"
  }
}

extension LiveStreamEvent.Firebase {
  enum CodingKeys: String, CodingKey {
    case apiKey = "firebase_api_key",
    chatAvatarUrl = "avatar",
    chatPath = "chat_path",
    chatPostPath = "chat_post_path",
    chatUserId = "user_id",
    chatUserName = "user_name",
    greenRoomPath = "green_room_path",
    hlsUrlPath = "hls_url_path",
    numberPeopleWatchingPath = "number_people_watching_path",
    project = "firebase_project",
    scaleNumberPeopleWatchingPath = "scale_number_people_watching_path",
    token
  }
}

extension LiveStreamEvent.OpenTok {
  enum CodingKeys: String, CodingKey {
    case appId = "app",
    sessionId = "session",
    token
  }
}

extension LiveStreamEvent.Project {
  enum CodingKeys: String, CodingKey {
    case id, uid, name, projectName =  "project_name", webURL = "web_url", projectWebUrl = "project_web_url"
    }

  public init(from decoder: Decoder) throws {
    let value = try decoder.container(keyedBy: CodingKeys.self)
    do {
      self.id = try value.decode(Int.self, forKey: .id)
    } catch {
      self.id  = try value.decode(Int.self, forKey: .uid)
    }

    do {
      self.name = try value.decode(String.self, forKey: .name)
    } catch {
      self.name = try value.decode(String.self, forKey: .projectName)
    }

    do {
      self.webUrl = try value.decode(String.self, forKey: .webURL)
    } catch {
      self.webUrl = try value.decode(String.self, forKey: .projectWebUrl)
    }
  }
}

extension LiveStreamEvent.User {
  enum CodingKeys: String, CodingKey {
    case isSubscribed = "is_subscribed"
  }
}

private let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  return dateFormatter
}()

private func toDate(dateString: String) -> Date {

  guard let date = dateFormatter.date(from: dateString) else {
    return .failure(DecodeError.custom("Unable to parse date format"))
  }

  return date
}

extension LiveStreamEvent {
  public enum lens {
    public static let backgroundImage = Lens<LiveStreamEvent, LiveStreamEvent.BackgroundImage>(
      view: { $0.backgroundImage },
      set: { var new = $1; new.backgroundImage = $0; return new }
    )
    public static let creator = Lens<LiveStreamEvent, LiveStreamEvent.Creator>(
      view: { $0.creator },
      set: { var new = $1; new.creator = $0; return new }
    )
    public static let description = Lens<LiveStreamEvent, String>(
      view: { $0.description },
      set: { var new = $1; new.description = $0; return new }
    )
    public static let firebase = Lens<LiveStreamEvent, LiveStreamEvent.Firebase?>(
      view: { $0.firebase },
      set: { var new = $1; new.firebase = $0; return new }
    )
    public static let hasReplay = Lens<LiveStreamEvent, Bool>(
      view: { $0.hasReplay },
      set: { var new = $1; new.hasReplay = $0; return new }
    )
    public static let hlsUrl = Lens<LiveStreamEvent, String?>(
      view: { $0.hlsUrl },
      set: { var new = $1; new.hlsUrl = $0; return new }
    )
    public static let id = Lens<LiveStreamEvent, Int>(
      view: { $0.id },
      set: { var new = $1; new.id = $0; return new }
    )
    public static let isRtmp = Lens<LiveStreamEvent, Bool?>(
      view: { $0.isRtmp },
      set: { var new = $1; new.isRtmp = $0; return new }
    )
    public static let isScale = Lens<LiveStreamEvent, Bool?>(
      view: { $0.isScale },
      set: { var new = $1; new.isScale = $0; return new }
    )
    public static let liveNow = Lens<LiveStreamEvent, Bool>(
      view: { $0.liveNow },
      set: { var new = $1; new.liveNow = $0; return new }
    )
    public static let maxOpenTokViewers = Lens<LiveStreamEvent, Int?>(
      view: { $0.maxOpenTokViewers },
      set: { var new = $1; new.maxOpenTokViewers = $0; return new }
    )
    public static let name = Lens<LiveStreamEvent, String>(
      view: { $0.name },
      set: { var new = $1; new.name = $0; return new }
    )
    public static let numberPeopleWatching = Lens<LiveStreamEvent, Int?>(
      view: { $0.numberPeopleWatching },
      set: { var new = $1; new.numberPeopleWatching = $0; return new }
    )
    public static let replayUrl = Lens<LiveStreamEvent, String?>(
      view: { $0.replayUrl },
      set: { var new = $1; new.replayUrl = $0; return new }
    )
    public static let startDate = Lens<LiveStreamEvent, Date>(
      view: { $0.startDate },
      set: { var new = $1; new.startDate = $0; return new }
    )
    public static let user = Lens<LiveStreamEvent, LiveStreamEvent.User?>(
      view: { $0.user },
      set: { var new = $1; new.user = $0; return new }
    )
    public static let webUrl = Lens<LiveStreamEvent, String>(
      view: { $0.webUrl },
      set: { var new = $1; new.webUrl = $0; return new }
    )
  }
}

extension LiveStreamEvent.Firebase {
  public enum lens {
    public static let apiKey = Lens<LiveStreamEvent.Firebase, String>(
      view: { $0.apiKey },
      set: { var new = $1; new.apiKey = $0; return new }
    )
    public static let chatAvatarUrl = Lens<LiveStreamEvent.Firebase, String?>(
      view: { $0.chatAvatarUrl },
      set: { var new = $1; new.chatAvatarUrl = $0; return new }
    )
    public static let chatPath = Lens<LiveStreamEvent.Firebase, String>(
      view: { $0.chatPath },
      set: { var new = $1; new.chatPath = $0; return new }
    )
    public static let chatPostPath = Lens<LiveStreamEvent.Firebase, String?>(
      view: { $0.chatPostPath },
      set: { var new = $1; new.chatPostPath = $0; return new }
    )
    public static let chatUserId = Lens<LiveStreamEvent.Firebase, String?>(
      view: { $0.chatUserId },
      set: { var new = $1; new.chatUserId = $0; return new }
    )
    public static let chatUserName = Lens<LiveStreamEvent.Firebase, String?>(
      view: { $0.chatUserName },
      set: { var new = $1; new.chatUserName = $0; return new }
    )
    public static let greenRoomPath = Lens<LiveStreamEvent.Firebase, String>(
      view: { $0.greenRoomPath },
      set: { var new = $1; new.greenRoomPath = $0; return new }
    )
    public static let hlsUrlPath = Lens<LiveStreamEvent.Firebase, String>(
      view: { $0.hlsUrlPath },
      set: { var new = $1; new.hlsUrlPath = $0; return new }
    )
    public static let numberPeopleWatchingPath = Lens<LiveStreamEvent.Firebase, String>(
      view: { $0.numberPeopleWatchingPath },
      set: { var new = $1; new.numberPeopleWatchingPath = $0; return new }
    )
    public static let project = Lens<LiveStreamEvent.Firebase, String>(
      view: { $0.project },
      set: { var new = $1; new.project = $0; return new }
    )
    public static let scaleNumberPeopleWatchingPath = Lens<LiveStreamEvent.Firebase, String>(
      view: { $0.scaleNumberPeopleWatchingPath },
      set: { var new = $1; new.scaleNumberPeopleWatchingPath = $0; return new }
    )
    public static let token = Lens<LiveStreamEvent.Firebase, String?>(
      view: { $0.token },
      set: { var new = $1; new.token = $0; return new }
    )
  }
}

extension LiveStreamEvent.Project {
  public enum lens {
    public static let id = Lens<LiveStreamEvent.Project, Int?>(
      view: { $0.id },
      set: { var new = $1; new.id = $0; return new }
    )

    public static let name = Lens<LiveStreamEvent.Project, String>(
      view: { $0.name },
      set: { var new = $1; new.name = $0; return new }
    )

    public static let webUrl = Lens<LiveStreamEvent.Project, String>(
      view: { $0.webUrl },
      set: { var new = $1; new.webUrl = $0; return new }
    )
  }
}
