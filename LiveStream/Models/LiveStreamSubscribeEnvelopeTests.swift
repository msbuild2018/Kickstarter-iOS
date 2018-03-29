import XCTest
import Argo
@testable import LiveStream

final class LiveStreamSubscribeEnvelopeTests: XCTestCase {
  func testParseJson_Success() {
    let json: [String: Any] = [
      "success": true
    ]

    let eventsEnvelope: LiveStreamSubscribeEnvelope? = LiveStreamSubscribeEnvelope.decodeJSONDictionary(json)

    XCTAssertNotNil(eventsEnvelope)
    XCTAssertEqual(true, eventsEnvelope?.success)
  }

  func testParseJson_Failure() {
    let json: [String: Any] = [
      "success": false,
      "reason": "A great reason"
    ]

    let eventsEnvelope: LiveStreamSubscribeEnvelope? = LiveStreamSubscribeEnvelope.decodeJSONDictionary(json)

    XCTAssertNotNil(eventsEnvelope)
    XCTAssertEqual(false, eventsEnvelope?.success)
    XCTAssertEqual("A great reason", eventsEnvelope?.reason)
  }
}
