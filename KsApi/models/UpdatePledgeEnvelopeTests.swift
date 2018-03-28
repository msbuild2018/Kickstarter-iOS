import XCTest
@testable import KsApi

final class UpdatePledgeEnvelopeTests: XCTestCase {

  func testDecodingWithStringStatus() {
    let decoded: UpdatePledgeEnvelope? = UpdatePledgeEnvelope.decodeJSONDictionary(["status": "200"])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded?.status)
  }

  func testDecodingWithIntStatus() {
    let decoded: UpdatePledgeEnvelope? = UpdatePledgeEnvelope.decodeJSONDictionary(["status": 200])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded?.status)
  }

  func testDecodingWithMissingStatus() {
    let decoded: UpdatePledgeEnvelope? = UpdatePledgeEnvelope.decodeJSONDictionary([:])
    XCTAssertNil(decoded)
  }

  func testDecodingWithBadStatusData() {
    let decoded: UpdatePledgeEnvelope? = UpdatePledgeEnvelope.decodeJSONDictionary(["status": "bad data"])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(0, decoded?.status)
  }
}
