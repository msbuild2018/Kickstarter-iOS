import Foundation
import Prelude


public struct LiveStreamEventsEnvelope: Swift.Decodable {
  public fileprivate(set) var numberOfLiveStreams: Int
  public fileprivate(set) var liveStreamEvents: [LiveStreamEvent]
}

extension LiveStreamEventsEnvelope {
  enum CodingKeys: String, CodingKey {
    case numberOfLiveStreams = "number_live_streams",
    liveStreamEvents = "live_streams"
  }
}

extension LiveStreamEventsEnvelope {
  public enum lens {
    public static let numberOfLiveStreams = Lens<LiveStreamEventsEnvelope, Int>(
      view: { $0.numberOfLiveStreams },
      set: { var new = $1; new.numberOfLiveStreams = $0; return new }
    )
    public static let liveStreamEvents = Lens<LiveStreamEventsEnvelope, [LiveStreamEvent]>(
      view: { $0.liveStreamEvents },
      set: { var new = $1; new.liveStreamEvents = $0; return new }
    )
  }
}
