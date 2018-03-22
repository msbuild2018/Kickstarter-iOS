import XCTest
@testable import KsApi

final class CreatePledgeEnvelopeTests: XCTestCase {

  func testDecodingWithStringStatus() {
    let decoded: CreatePledgeEnvelope? = CreatePledgeEnvelope.decodeJSONDictionary(["status": "200"])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded?.status)
  }

  func testDecodingWithIntStatus() {
    let decoded: CreatePledgeEnvelope? = CreatePledgeEnvelope.decodeJSONDictionary(["status": 200])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded?.status)
  }

  func testDecodingWithMissingStatus() {
    let decoded: CreatePledgeEnvelope? = CreatePledgeEnvelope.decodeJSONDictionary([:])
    XCTAssertNil(decoded)
  }

  func testDecodingWithBadStatusData() {
    let decoded: CreatePledgeEnvelope? = CreatePledgeEnvelope.decodeJSONDictionary(["status": "bad data"])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(0, decoded?.status)
  }
}
