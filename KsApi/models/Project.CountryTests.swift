import XCTest
@testable import KsApi

final class ProjectCountryTests: XCTestCase {

  func testEquatable() {
    XCTAssertEqual(Project.Country.us, Project.Country.us)
    XCTAssertNotEqual(Project.Country.us, Project.Country.ca)
    XCTAssertNotEqual(Project.Country.us, Project.Country.au)
    XCTAssertNotEqual(Project.Country.de, Project.Country.es)
  }

  func testDescription() {
    XCTAssertNotEqual(Project.Country.us.description, "")
  }

  func testJsonDecoding_StandardJSON() {
    let decodedCountry: Project.Country? = Project.Country.decodeJSONDictionary([
      "country": "US",
      "currency": "USD",
      "currency_symbol": "$",
      "currency_trailing_code": true
      ])

    XCTAssertEqual(.us, decodedCountry)

    // swiftlint:disable:next force_unwrapping
    let country = decodedCountry!
    XCTAssertEqual(country, Project.Country.decodeJSONDictionary(country.encode()))
  }

  func testJsonDecoding_ConfigJSON() {
    let decodedCountry: Project.Country! = Project.Country.decodeJSONDictionary([
      "name": "US",
      "currency_code": "USD",
      "currency_symbol": "$",
      "trailing_code": true
      ])

    XCTAssertEqual(.us, decodedCountry)

    // swiftlint:disable:next force_unwrapping
    let country: Project.Country = decodedCountry!
    XCTAssertEqual(country, Project.Country.decodeJSONDictionary(country.encode()))
  }
}
