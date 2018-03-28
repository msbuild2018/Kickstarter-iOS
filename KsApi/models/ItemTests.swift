import Prelude
import XCTest
@testable import KsApi

final class ItemTests: XCTestCase {

  func testDecoding() {
    let decoded: Item? = Item.decodeJSONDictionary([
      "description": "Hello",
      "id": 1,
      "name": "The thing",
      "project_id": 1
    ])

    XCTAssertNotNil(decoded)
    XCTAssertEqual("Hello", decoded?.description)
    XCTAssertEqual(1, decoded?.id)
    XCTAssertEqual("The thing", decoded?.name)
    XCTAssertEqual(1, decoded?.projectId)
  }
}
