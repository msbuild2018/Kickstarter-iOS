import XCTest
@testable import KsApi
@testable import Argo

class ErrorEnvelopeTests: XCTestCase {

  func testJsonDecodingWithFullData() {
    let env: ErrorEnvelope? = ErrorEnvelope.decodeJSONDictionary([
      "error_messages": ["hello"],
      "ksr_code": "access_token_invalid",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
      ])
    XCTAssertNotNil(env)
  }

  func testJsonDecodingWithBadKsrCode() {
    let env: ErrorEnvelope? = ErrorEnvelope.decodeJSONDictionary([
      "error_messages": ["hello"],
      "ksr_code": "doesnt_exist",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
      ])
    XCTAssertNotNil(env)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env?.ksrCode)
  }

  // FIXME: write backer_reward test too
  func testJsonDecodingWithNonStandardError() {
    let env: ErrorEnvelope? = ErrorEnvelope.decodeJSONDictionary([
      "status": 406,
      "data": [
        "errors": [
          "amount": [
            "Bad amount"
          ]
        ]
      ]
    ])
    XCTAssertNotNil(env)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env?.ksrCode)
    // swiftlint:disable:next force_unwrapping
    XCTAssertEqual(["Bad amount"], env!.errorMessages)
    XCTAssertEqual(406, env?.httpCode)
  }
}
