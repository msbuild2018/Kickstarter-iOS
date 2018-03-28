import XCTest
@testable import KsApi
@testable import Argo

class ErrorEnvelopeTests: XCTestCase {

  func testJsonDecodingWithFullData() {

    let json: [String: Any] = [
      "error_messages": ["hello"],
      "ksr_code": "access_token_invalid",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
    ]

    let env: ErrorEnvelope? = ErrorEnvelope.decodeJSONDictionary(json)
    XCTAssertNotNil(env)
  }

  func testJsonDecodingWithBadKsrCode() {

    let json: [String: Any] = [
      "error_messages": ["hello"],
      "ksr_code": "doesnt_exist",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
    ]

    let env: ErrorEnvelope? = ErrorEnvelope.decodeJSONDictionary(json)
    XCTAssertNotNil(env)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env?.ksrCode)
  }

  // FIXME: write backer_reward test too
  func testJsonDecodingWithNonStandardError() {

    let json: [String: Any] = [
      "status": 406,
      "data": [
        "errors": [
          "amount": [
            "Bad amount"
          ]
        ]
      ]
    ]
    
    let env: ErrorEnvelope? = ErrorEnvelope.decodeJSONDictionary(json)
    XCTAssertNotNil(env)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env?.ksrCode)
    // swiftlint:disable:next force_unwrapping
    XCTAssertEqual(["Bad amount"], env!.errorMessages)
    XCTAssertEqual(406, env?.httpCode)
  }
}
