import XCTest
@testable import KsApi

final class ProjectVideoTests: XCTestCase {

  func testJsonParsing_WithFullData() {

    let json: [String: Any] = [
      "id": 1,
      "high": "kickstarter.com/video.mp4"
    ]

    let video: Project.Video? = Project.Video.decodeJSONDictionary(json)

    XCTAssertNotNil(video)
    XCTAssertEqual(video?.id, 1)
    XCTAssertEqual(video?.high, "kickstarter.com/video.mp4")
  }
}
