import XCTest
@testable import KsApi

final class BackingTests: XCTestCase {

  func testJSONDecoding_WithCompleteData() {
    let backing: Backing? = Backing.decodeJSONDictionary([
      "amount": 1.0,
      "backer_id": 1,
      "id": 1,
      "location_id": 1,
      "pledged_at": 1000,
      "project_country": "US",
      "project_id": 1,
      "sequence": 1,
      "status": "pledged"
    ])

    XCTAssertNotNil(backing)
    XCTAssertEqual(1, backing?.id)
    XCTAssertEqual(Backing.Status.pledged, backing?.status)
  }
}
