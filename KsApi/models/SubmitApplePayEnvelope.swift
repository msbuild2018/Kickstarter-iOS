import Foundation

public struct SubmitApplePayEnvelope: Swift.Decodable {
  public let thankYouUrl: String
  public let status: Int

  struct SubmitApplePayData: Swift.Decodable {
    let thankYouUrl: String
  }
}

extension SubmitApplePayEnvelope.SubmitApplePayData {
  enum CodingKeys: String, CodingKey {
    case thankYouUrl = "thankyou_url"
  }
}

extension SubmitApplePayEnvelope {
  enum CodingKeys: String, CodingKey {
    case data,
    status
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.thankYouUrl = try container.decode(SubmitApplePayData.self, forKey: .data).thankYouUrl
    let statusString = try container.decode(String.self, forKey: .status)
    self.status = stringToIntOrZero(statusString)
  }
}

private func stringToIntOrZero(_ string: String) -> Int {
  return
    Double(string).flatMap(Int.init) ?? Int(string) ?? 0
}
