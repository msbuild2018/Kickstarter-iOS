import XCTest
import KsApi
@testable import LiveStream

private struct TestFirebaseDataSnapshotType: FirebaseDataSnapshotType {
  let key: String
  let value: Any?
}

final class LiveStreamChatMessageTests: XCTestCase {
  func testParseJson() {
    let json: [String: Any] = [
      "id": "KDeCy9vvd7ZCRwHc8Ca",
      "creator": false,
      "message": "Test chat message",
      "name": "Test Name",
      "profilePic": "http://www.kickstarter.com/picture.jpg",
      "timestamp": 1234234123,
      "userId": "id_1312341234321"
    ]

    let chatMessage: LiveStreamChatMessage? = LiveStreamChatMessage.decodeJSONDictionary(json)

    XCTAssertNotNil(chatMessage)
    XCTAssertEqual("KDeCy9vvd7ZCRwHc8Ca", chatMessage?.id)
    XCTAssertEqual(false, chatMessage?.isCreator)
    XCTAssertEqual("Test chat message", chatMessage?.message)
    XCTAssertEqual("Test Name", chatMessage?.name)
    XCTAssertEqual("http://www.kickstarter.com/picture.jpg", chatMessage?.profilePictureUrl)
    XCTAssertEqual(1234234123, chatMessage?.date)
    XCTAssertEqual("id_1312341234321", chatMessage?.userId)
  }

  func testParseFirebaseDataSnapshot() {
    let snapshot = TestFirebaseDataSnapshotType(
      key: "KDeCy9vvd7ZCRwHc8Ca", value: [
        "id": "KDeCy9vvd7ZCRwHc8Ca",
        "creator": false,
        "message": "Test chat message",
        "name": "Test Name",
        "profilePic": "http://www.kickstarter.com/picture.jpg",
        "timestamp": 1234234123,
        "userId": "id_1312341234321"
      ])

    let chatMessage = LiveStreamChatMessage.decode(snapshot)

    XCTAssertNotNil(chatMessage)
    XCTAssertEqual("KDeCy9vvd7ZCRwHc8Ca", chatMessage.id)
    XCTAssertEqual(false, chatMessage.isCreator)
    XCTAssertEqual("Test chat message", chatMessage.message)
    XCTAssertEqual("Test Name", chatMessage.name)
    XCTAssertEqual("http://www.kickstarter.com/picture.jpg", chatMessage.profilePictureUrl)
    XCTAssertEqual(1234234123, chatMessage.date)
    XCTAssertEqual("id_1312341234321", chatMessage.userId)
  }
}
