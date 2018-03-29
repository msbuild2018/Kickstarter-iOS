import XCTest
@testable import KsApi

final class SubmitApplePayEnvelopeTests: XCTestCase {

  func testDecodingWithStringStatus() {
    let decoded: SubmitApplePayEnvelope? = SubmitApplePayEnvelope.decodeJSONDictionary(
      [
        "data": [
          "thankyou_url": "https://www.kickstarter.com/thanks"
        ],
        "status": "200"
      ]
    )

    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded?.status)
  }

  func testDecodingWithStatus() {
    let decoded: SubmitApplePayEnvelope? = SubmitApplePayEnvelope.decodeJSONDictionary(
      [
        "data": [
          "thankyou_url": "https://www.kickstarter.com/thanks"
        ],
        "status": 200
      ]
    )

    XCTAssertNotNil(decoded)
    XCTAssertEqual(200, decoded?.status)
  }

  func testDecodingWithMissingStatus() {

    let decoded: SubmitApplePayEnvelope? = SubmitApplePayEnvelope.decodeJSONDictionary(
      [
        "data": [
          "thankyou_url": "https://www.kickstarter.com/thanks"
        ]
      ]
    )

    XCTAssertNil(decoded)
  }

  func testDecodingWithBadStatusData() {
    let decoded: SubmitApplePayEnvelope? = SubmitApplePayEnvelope.decodeJSONDictionary(
      [
        "data": [
          "thankyou_url": "bad data"
        ],
        "status": "bad data"
      ]
    )

    XCTAssertNotNil(decoded)
    XCTAssertEqual(0, decoded?.status)
  }
}
