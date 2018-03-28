import Argo
@testable import KsApi
import XCTest

final internal class SurveyResponseTests: XCTestCase {
  func testJSONDecoding() {
    let decoded: SurveyResponse? = SurveyResponse.decodeJSONDictionary([
      "id": 1,
      "urls": [
        "web": [
          "survey": "http://"
        ]
      ]
      ])

    XCTAssertNotNil(decoded)
    XCTAssertEqual(1, decoded?.id)
  }
}
