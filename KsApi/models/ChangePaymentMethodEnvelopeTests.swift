import XCTest
@testable import KsApi

final class ChangePaymentMethodEnvelopeTests: XCTestCase {

  func testDecodingWithStringStatus() {
    let decoded: ChangePaymentMethodEnvelope! = ChangePaymentMethodEnvelope
                                                  .decodeJSONDictionary(["status": "200"])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded.status)
  }

  func testDecodingWithIntStatus() {
    let decoded: ChangePaymentMethodEnvelope! = ChangePaymentMethodEnvelope
                                                  .decodeJSONDictionary(["status": 200])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded?.status)
  }

  func testDecodingWithMissingStatus() {
    let decoded: ChangePaymentMethodEnvelope! = ChangePaymentMethodEnvelope.decodeJSONDictionary([:])
    XCTAssertNil(decoded)
  }

  func testDecodingWithBadStatusData() {
    let decoded: ChangePaymentMethodEnvelope! = ChangePaymentMethodEnvelope
                                                  .decodeJSONDictionary(["status": "bad data"])
    XCTAssertNotNil(decoded)
    XCTAssertEqual(0, decoded?.status)
  }
}
