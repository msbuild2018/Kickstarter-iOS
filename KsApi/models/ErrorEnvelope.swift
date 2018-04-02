import Argo
import Curry
import Runes

public struct ErrorEnvelope: Swift.Decodable {
  public let errorMessages: [String]
  public let ksrCode: KsrCode?
  public let httpCode: Int
  public let exception: Exception?
  public let facebookUser: FacebookUser?

  public init(errorMessages: [String], ksrCode: KsrCode?, httpCode: Int, exception: Exception?,
              facebookUser: FacebookUser? = nil) {
    self.errorMessages = errorMessages
    self.ksrCode = ksrCode
    self.httpCode = httpCode
    self.exception = exception
    self.facebookUser = facebookUser
  }

  public enum KsrCode: String, Swift.Decodable {
    // Codes defined by the server
    case AccessTokenInvalid = "access_token_invalid"
    case ConfirmFacebookSignup = "confirm_facebook_signup"
    case FacebookConnectAccountTaken = "facebook_connect_account_taken"
    case FacebookConnectEmailTaken = "facebook_connect_email_taken"
    case FacebookInvalidAccessToken = "facebook_invalid_access_token"
    case InvalidXauthLogin = "invalid_xauth_login"
    case MissingFacebookEmail = "missing_facebook_email"
    case TfaFailed = "tfa_failed"
    case TfaRequired = "tfa_required"

    // Catch all code for when server sends code we don't know about yet
    case UnknownCode = "__internal_unknown_code"

    // Codes defined by the client
    case JSONParsingFailed = "json_parsing_failed"
    case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
    case DecodingJSONFailed = "decoding_json_failed"
    case InvalidPaginationUrl = "invalid_pagination_url"
  }

  public struct Exception: Swift.Decodable {
    public let backtrace: [String]?
    public let message: String?
  }

  public struct FacebookUser: Swift.Decodable {
    public let id: Int64
    public let name: String
    public let email: String
  }

  /**
   A general error that JSON could not be parsed.
  */
  internal static let couldNotParseJSON = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .JSONParsingFailed,
    httpCode: 400,
    exception: nil,
    facebookUser: nil
  )

  /**
   A general error that the error envelope JSON could not be parsed.
  */
  internal static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .ErrorEnvelopeJSONParsingFailed,
    httpCode: 400,
    exception: nil,
    facebookUser: nil
  )

  /**
   A general error that some JSON could not be decoded.

   - parameter decodeError: The Argo decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static func couldNotDecodeJSON(_ decodeError: DecodeError) -> ErrorEnvelope {
    return ErrorEnvelope(
      errorMessages: ["Argo decoding error: \(decodeError.description)"],
      ksrCode: .DecodingJSONFailed,
      httpCode: 400,
      exception: nil,
      facebookUser: nil
    )
  }

  /**
   A error that the pagination URL is invalid.

   - parameter decodeError: The Argo decoding error.

   - returns: An error envelope that describes why decoding failed.
   */
  internal static let invalidPaginationUrl = ErrorEnvelope(
    errorMessages: [],
    ksrCode: .InvalidPaginationUrl,
    httpCode: 400,
    exception: nil,
    facebookUser: nil
  )

  public struct ErrorEnvelopeData: Swift.Decodable {
    let errors: [String: [String]]
  }
}

extension ErrorEnvelope: Error {}

extension ErrorEnvelope.ErrorEnvelopeData {
  enum CodingKeys: String, CodingKey {
    case errors
  }
}

extension ErrorEnvelope.Exception {
  enum CodingKeys: String, CodingKey {
    case backtrace, message
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.backtrace = try? container.decode([String].self, forKey: .backtrace)
    self.message = try? container.decode(String.self, forKey: .message)
  }
}

extension ErrorEnvelope {

  fileprivate enum CodingKeys: String, CodingKey {
    case data
    case errorMessages = "error_messages"
    case ksrCode = "ksr_code"
    case httpCode = "http_code"
    case exception
    case facebookUser = "facebook_user"
    case status // Only used in non-standard error envelope
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    var errorMessages: [String]
    var ksrCode: KsrCode?
    var httpCode: Int
    var exception: Exception?
    var facebookUser: FacebookUser?

    // Typically API errors come back in this form...
    do {
      errorMessages = try container.decode([String].self, forKey: .errorMessages)
      ksrCode = retrieveKsrCode(with: container)
      httpCode = try container.decode(Int.self, forKey: .httpCode)
      exception = try? container.decode(Exception.self, forKey: .exception)
      facebookUser = try? container.decode(FacebookUser.self, forKey: .facebookUser)
    } catch {
      // ...but sometimes we make requests to the www server and JSON errors come back in a different envelope
      do {

        let errorDictionary = try container.decode(ErrorEnvelopeData.self, forKey: .data).errors

        errorMessages = errorDictionary.keys.flatMap {
          retrieveErrorString(from: errorDictionary, key: $0)
        }.sconcat([])

        ksrCode = ErrorEnvelope.KsrCode.UnknownCode
        httpCode = try container.decode(Int.self, forKey: .status)
        exception = nil
        facebookUser = nil
      }
    }

    self.errorMessages = errorMessages
    self.ksrCode = ksrCode
    self.httpCode = httpCode
    self.exception = exception
    self.facebookUser = facebookUser
  }
}

private func retrieveKsrCode(with container: KeyedDecodingContainer<ErrorEnvelope.CodingKeys>)
  -> ErrorEnvelope.KsrCode? {

  do {
    let code =  try container.decode(ErrorEnvelope.KsrCode?.self, forKey: .ksrCode)
    return code
  } catch {
    return ErrorEnvelope.KsrCode.UnknownCode
  }
}

private func retrieveErrorString(from dictionary: [String: Any?], key: String) -> [String]? {

  if let amount = dictionary["amount"] as? [String] {
    return amount
  }

  if let backerReward = dictionary["backer_reward"] as? [String] {
    return backerReward
  }

  return nil
}

extension ErrorEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ErrorEnvelope> {

    // Typically API errors come back in this form...
    let standardErrorEnvelope = curry(ErrorEnvelope.init)
      <^> json <|| "error_messages"
      <*> json <|? "ksr_code"
      <*> json <| "http_code"
      <*> json <|? "exception"
      <*> json <|? "facebook_user"

    // ...but sometimes we make requests to the www server and JSON errors come back in a different envelope
    let nonStandardErrorEnvelope = {
      curry(ErrorEnvelope.init)
        <^> concatSuccesses([
          json <|| ["data", "errors", "amount"],
          json <|| ["data", "errors", "backer_reward"],
          ])
        <*> .success(ErrorEnvelope.KsrCode.UnknownCode)
        <*> json <| "status"
        <*> .success(nil)
        <*> .success(nil)
    }

    return standardErrorEnvelope <|> nonStandardErrorEnvelope()
  }
}

extension ErrorEnvelope.Exception: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ErrorEnvelope.Exception> {
    return curry(ErrorEnvelope.Exception.init)
      <^> json <||? "backtrace"
      <*> json <|? "message"
  }
}

extension ErrorEnvelope.KsrCode: Argo.Decodable {
  public static func decode(_ j: JSON) -> Decoded<ErrorEnvelope.KsrCode> {
    switch j {
    case let .string(s):
      return pure(ErrorEnvelope.KsrCode(rawValue: s) ?? ErrorEnvelope.KsrCode.UnknownCode)
    default:
      return .typeMismatch(expected: "ErrorEnvelope.KsrCode", actual: j)
    }
  }
}

extension ErrorEnvelope.FacebookUser: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<ErrorEnvelope.FacebookUser> {
    return curry(ErrorEnvelope.FacebookUser.init)
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "email"
  }
}

// Concats an array of decoded arrays into a decoded array. Ignores all failed decoded values, and so
// always returns a successfully decoded value.
private func concatSuccesses<A>(_ decodeds: [Decoded<[A]>]) -> Decoded<[A]> {

  return decodeds.reduce(Decoded.success([])) { accum, decoded in
    .success( (accum.value ?? []) + (decoded.value ?? []) )
  }
}
