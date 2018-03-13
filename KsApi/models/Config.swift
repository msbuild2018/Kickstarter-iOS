import Foundation

public enum Experiment {

  public enum Name: String {
    case iosTest = "ios_test_test"
  }

  public enum Variant: String {
    case control //default
    case experimental
  }
}

public struct Config: Swift.Decodable {
  public private(set) var abExperiments: [String: String]
  public private(set) var appId: Int
  public private(set) var applePayCountries: [String]
  public private(set) var countryCode: String
  public private(set) var features: [String: Bool]
  public private(set) var iTunesLink: String
  public private(set) var launchedCountries: [Project.Country]
  public private(set) var locale: String
  public private(set) var stripePublishableKey: String

  public struct Stripe: Swift.Decodable {
    let stripePublishableKey: String
  }

  public var abExperimentsArray: [String] {
    let stringsArray = self.abExperiments.map { (key, value) in
      key + "[\(value)]"
    }
    return stringsArray
  }
}

extension Config.Stripe {
  enum CodingKeys: String, CodingKey {
    case stripePublishableKey = "publishable_key"
  }
}

extension Config: EncodableType {
  enum CodingKeys: String, CodingKey {
    case abExperiments = "ab_experiments",
    appId = "app_id",
    applePayCountries = "apple_pay_countries",
    countryCode = "country_code",
    features = "features",
    iTunesLink = "itunes_link",
    launchedCountries = "launched_countries",
    locale,
    stripe
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.abExperiments = try container.decode([String: String].self, forKey: .abExperiments)
    self.appId = try container.decode(Int.self, forKey: .appId)
    self.applePayCountries = try container.decode([String].self, forKey: .applePayCountries)
    self.countryCode = try container.decode(String.self, forKey: .countryCode)
    self.features = try container.decode([String: Bool].self, forKey: .features)
    self.iTunesLink = try container.decode(String.self, forKey: .iTunesLink)
    self.launchedCountries = try container.decode([Project.Country].self, forKey: .launchedCountries)
    self.locale = try container.decode(String.self, forKey: .locale)
    self.stripePublishableKey = try container.decode(Config.Stripe.self, forKey: .stripe).stripePublishableKey
  }

  public func encode() -> [String: Any] {
    var result: [String:Any] = [:]
    result["ab_experiments"] = self.abExperiments
    result["app_id"] = self.appId
    result["apple_pay_countries"] = self.applePayCountries
    result["country_code"] = self.countryCode
    result["features"] = self.features
    result["itunes_link"] = self.iTunesLink
    result["launched_countries"] = self.launchedCountries.map { $0.encode() }
    result["locale"] = self.locale
    result["stripe"] = ["publishable_key": self.stripePublishableKey]
    return result
  }
}

extension Config: Equatable {}
public func == (lhs: Config, rhs: Config) -> Bool {
  return lhs.abExperiments == rhs.abExperiments &&
    lhs.appId == rhs.appId &&
    lhs.applePayCountries == rhs.applePayCountries &&
    lhs.countryCode == rhs.countryCode &&
    lhs.features == rhs.features &&
    lhs.iTunesLink == rhs.iTunesLink &&
    lhs.launchedCountries == rhs.launchedCountries &&
    lhs.locale == rhs.locale &&
    lhs.stripePublishableKey == rhs.stripePublishableKey
}
