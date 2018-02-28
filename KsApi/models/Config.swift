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

public struct Config: Swift.Decodable, Swift.Encodable {
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

extension Config {
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

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.abExperiments, forKey: .abExperiments)
    try container.encode(self.appId, forKey: .appId)
    try container.encode(self.applePayCountries, forKey: .applePayCountries)
    try container.encode(self.countryCode, forKey: .countryCode)
    try container.encode(self.features, forKey: .features)
    try container.encode(self.iTunesLink, forKey: .iTunesLink)
    try container.encode(self.launchedCountries, forKey: .launchedCountries)
    try container.encode(self.locale, forKey: .locale)
    try container.encode(["publishable_key": self.stripePublishableKey], forKey: .stripe)
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
