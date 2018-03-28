import XCTest
@testable import KsApi
import Prelude

final class PushEnvelopeTests: XCTestCase {
  func testDecode_Update_WithUpdateKey() {
    let decodedEnvelope: PushEnvelope? = PushEnvelope.decodeJSONDictionary([
      "aps": [
        "alert": "Hi"
      ],
      "update": [
        "id": 1,
        "project_id": 2
      ]
    ])

    XCTAssertNotNil(decodedEnvelope)
    XCTAssertNotNil(decodedEnvelope?.update)
    XCTAssertEqual(1, decodedEnvelope?.update?.id)
    XCTAssertEqual(2, decodedEnvelope?.update?.projectId)
  }

  func testDecode_Update_WithPostKey() {
    let decodedEnvelope: PushEnvelope? = PushEnvelope.decodeJSONDictionary([
      "aps": [
        "alert": "Hi"
      ],
      "post": [
        "id": 1,
        "project_id": 2
      ]
      ])

    XCTAssertNotNil(decodedEnvelope)
    XCTAssertNotNil(decodedEnvelope?.update)
    XCTAssertEqual(1, decodedEnvelope?.update?.id)
    XCTAssertEqual(2, decodedEnvelope?.update?.projectId)
  }
}
