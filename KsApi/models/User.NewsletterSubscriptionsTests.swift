import XCTest
@testable import KsApi

final class NewsletterSubscriptionsTests: XCTestCase {

  func testJsonEncoding() {
    let json: [String: AnyHashable] = [
      "games_newsletter": false,
      "promo_newsletter": false,
      "happening_newsletter": false,
      "weekly_newsletter": false
    ]

    let newsletter: User.NewsletterSubscriptions? = User.NewsletterSubscriptions.decodeJSONDictionary(json)

    XCTAssertEqual(newsletter?.encode().description, json.description)

    XCTAssertEqual(false, newsletter?.weekly)
    XCTAssertEqual(false, newsletter?.promo)
    XCTAssertEqual(false, newsletter?.happening)
    XCTAssertEqual(false, newsletter?.games)
  }

  func testJsonEncoding_TrueValues() {
    let json: [String: AnyHashable] = [
      "games_newsletter": true,
      "promo_newsletter": true,
      "happening_newsletter": true,
      "weekly_newsletter": true
    ]

    let newsletter: User.NewsletterSubscriptions? = User.NewsletterSubscriptions.decodeJSONDictionary(json)

    XCTAssertEqual(newsletter?.encode().description, json.description)

    XCTAssertEqual(true, newsletter?.weekly)
    XCTAssertEqual(true, newsletter?.promo)
    XCTAssertEqual(true, newsletter?.happening)
    XCTAssertEqual(true, newsletter?.games)
  }

  func testJsonDecoding() {
    let json: [String: AnyHashable] = [
      "games_newsletter": true,
      "happening_newsletter": false,
      "promo_newsletter": true,
      "weekly_newsletter": false
    ]

    let newsletters: User.NewsletterSubscriptions? = User.NewsletterSubscriptions.decodeJSONDictionary(json)
    let emptyDic: [String: AnyHashable] = [:]
    XCTAssertEqual(newsletters,
                   User.NewsletterSubscriptions.decodeJSONDictionary(newsletters?.encode() ?? emptyDic))
  }
}
