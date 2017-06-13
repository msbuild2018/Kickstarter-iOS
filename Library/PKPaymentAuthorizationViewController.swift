import PassKit

extension PKPaymentAuthorizationViewController {

  public static var merchantIdentifier: String {
    return "merchant.com.kickstarter"
  }

  public static var supportedNetworks: [PKPaymentNetwork] {
    let supported = [PKPaymentNetwork.amex, .masterCard, .visa]

    if AppEnvironment.current.config?.features["ios_apple_pay_discover"] != .some(false) {
      return supported + [.discover]
    }

    return supported
  }

  public static func applePayCapable() -> Bool {
    return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks)
  }

  public static func applePayDevice() -> Bool {
    return PKPaymentAuthorizationViewController.canMakePayments()
  }
}
