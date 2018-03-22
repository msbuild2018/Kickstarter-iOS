import Argo
import Prelude
import XCTest
@testable import KsApi

class DiscoveryParamsTests: XCTestCase {

  func testDefault() {
    let params = DiscoveryParams.defaults
    XCTAssertNil(params.staffPicks)
  }

  func testQueryParams() {
    XCTAssertEqual([:], DiscoveryParams.defaults.queryParams)

    let params = DiscoveryParams.defaults
      |> DiscoveryParams.lens.staffPicks .~ true
      |> DiscoveryParams.lens.hasVideo .~ true
      |> DiscoveryParams.lens.starred .~ true
      |> DiscoveryParams.lens.backed .~ false
      |> DiscoveryParams.lens.social .~ true
      |> DiscoveryParams.lens.recommended .~ true
      |> DiscoveryParams.lens.similarTo .~ Project.template
      |> DiscoveryParams.lens.category .~ Category.art
      |> DiscoveryParams.lens.query .~ "wallet"
      |> DiscoveryParams.lens.state .~ .live
      |> DiscoveryParams.lens.sort .~ .popular
      |> DiscoveryParams.lens.page .~ 1
      |> DiscoveryParams.lens.perPage .~ 20
      |> DiscoveryParams.lens.seed .~ 123

    let queryParams: [String: String] = [
      "staff_picks": "true",
      "has_video": "true",
      "backed": "-1",
      "social": "1",
      "recommended": "true",
      "category_id": Category.art.intID?.description ?? "-1",
      "term": "wallet",
      "state": "live",
      "starred": "1",
      "sort": "popularity",
      "page": "1",
      "per_page": "20",
      "seed": "123",
      "similar_to": Project.template.id.description
    ]

    XCTAssertEqual(queryParams, params.queryParams)
  }

  func testEquatable() {
    let params = DiscoveryParams.defaults
    XCTAssertEqual(params, params)
  }

  func testStringConvertible() {
    let params = DiscoveryParams.defaults
    XCTAssertNotNil(params.description)
    XCTAssertNotNil(params.debugDescription)
  }

  func testPOTD() {
    let p1 = DiscoveryParams.defaults
      |> DiscoveryParams.lens.includePOTD .~ true
    XCTAssertEqual([:], p1.queryParams,
                   "POTD flag is included with no filter.")

    let p2 = DiscoveryParams.defaults
      |> DiscoveryParams.lens.includePOTD .~ true
      |> DiscoveryParams.lens.sort .~ .magic
    XCTAssertEqual(["sort": "magic"],
                   p2.queryParams,
                   "POTD flag is included with no filter + magic sort.")
  }

  private func decodedParam(with json: [String: AnyHashable]) -> DiscoveryParams {
     return DiscoveryParams.decodeJSONDictionary(json)!
  }

  func testDecode() {

    XCTAssertNil(decodedParam(with: [:]).backed, "absent values aren't set")
    XCTAssertNil(DiscoveryParams.decodeJSONDictionary(["backed": "nope"])!, "invalid values error")

    // server logic
    XCTAssertEqual(true, decodedParam(with: ["has_video": "true"]).hasVideo)
    XCTAssertEqual(true, decodedParam(with: ["has_video": "1"]).hasVideo)
    XCTAssertEqual(true, decodedParam(with: ["has_video": "t"]).hasVideo)
    XCTAssertEqual(true, decodedParam(with: ["has_video": "T"]).hasVideo)
    XCTAssertEqual(true, decodedParam(with: ["has_video": "TRUE"]).hasVideo)
    XCTAssertEqual(true, decodedParam(with: ["has_video": "on"]).hasVideo)
    XCTAssertEqual(true, decodedParam(with: ["has_video": "ON"]).hasVideo)
    XCTAssertEqual(false, decodedParam(with: ["has_video": "false"]).hasVideo)
    XCTAssertEqual(false, decodedParam(with: ["has_video": "0"]).hasVideo)
    XCTAssertEqual(false, decodedParam(with: ["has_video": "f"]).hasVideo)
    XCTAssertEqual(false, decodedParam(with: ["has_video": "F"]).hasVideo)
    XCTAssertEqual(false, decodedParam(with: ["has_video": "FALSE"]).hasVideo)
    XCTAssertEqual(false, decodedParam(with: ["has_video": "off"]).hasVideo)
    XCTAssertEqual(false, decodedParam(with: ["has_video": "OFF"]).hasVideo)

    XCTAssertEqual(true, decodedParam(with: ["include_potd": "true"]).includePOTD)
    XCTAssertEqual(true, decodedParam(with: ["recommended": "true"]).recommended)
    XCTAssertEqual(true, decodedParam(with: ["staff_picks": "true"]).staffPicks)

    XCTAssertEqual(40, decodedParam(with: ["page": "40"]).page)
    XCTAssertEqual(41, decodedParam(with: ["per_page": "41"]).perPage)
    XCTAssertEqual(42, decodedParam(with: ["seed": "42"]).seed)

    XCTAssertNil(decodedParam(with: ["backed": "42"]))
    XCTAssertNil(decodedParam(with: ["backed": "0"]).backed)
    XCTAssertEqual(true, decodedParam(with: ["backed": "1"]).backed)
    XCTAssertEqual(false, decodedParam(with: ["backed": "-1"]).backed)

    XCTAssertEqual(false, decodedParam(with: ["social": "-1"]).social)
    XCTAssertEqual(false, decodedParam(with: ["starred": "-1"]).starred)

    XCTAssertEqual("bugs", decodedParam(with: ["term": "bugs"]).query)
    XCTAssertEqual(.magic, decodedParam(with: ["sort": "magic"]).sort)
    XCTAssertEqual(.live, decodedParam(with: ["state": "live"]).state)
  }
}
