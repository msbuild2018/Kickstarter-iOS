import XCTest
@testable import KsApi
import Prelude

final class LocationTests: XCTestCase {

  func testEquatable() {
    XCTAssertEqual(Location.template, Location.template)
    XCTAssertNotEqual(Location.template, Location.template |> Location.lens.id %~ { $0 + 1 })
  }

  func testJSONParsing_WithPartialData() {

    let location: Location! = Location.decodeJSONDictionary([
      "id": 1
    ])

    XCTAssertNil(location)
  }

  func testJSONParsing_WithFullData() {

    let location: Location! = Location.decodeJSONDictionary([
      "country": "US",
      "id": 1,
      "displayable_name": "Brooklyn, NY",
      "localized_name": "Brooklyn, NY",
      "name": "Brooklyn"
    ])

    XCTAssertNotNil(location)
    XCTAssertEqual(location?.id, 1)
    XCTAssertEqual(location?.displayableName, "Brooklyn, NY")
    XCTAssertEqual(location?.localizedName, "Brooklyn, NY")
    XCTAssertEqual(location?.name, "Brooklyn")
  }

  func testEncodeDecode() {
    let location: [String: Any] = [
      "country": "US",
      "id": 44,
      "displayable_name": "New Amsterdam, NY",
      "localized_name": "New Amsterdam, NY",
      "name": "New Amsterdam"
    ]

    let decodedLocation: Location? = Location.decodeJSONDictionary(location)

    XCTAssertEqual(decodedLocation, Location.decodeJSONDictionary(decodedLocation?.encode() ?? [:]))
    XCTAssertEqual(decodedLocation?.encode() as NSDictionary?, location as NSDictionary?)
  }
}
