import UIKit
import PassKit
import Flutter
import GoogleMaps
import Stripe

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, STPAddCardViewControllerDelegate, STPApplePayContextDelegate, STPAuthenticationContext {
    
    var controller : FlutterViewController!
    var promise: FlutterResult!
    var clientSecretKey: String = ""
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDi2i0HqPy63HuDJ4ralb4AlSKSWXf-L44")
    StripeAPI.defaultPublishableKey = "pk_live_xJZNL46qlomZrNkdZk3ANXDq002KY0KlBT"
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    controller = window?.rootViewController as? FlutterViewController
    let channel = FlutterMethodChannel(name: "com.range.takk/callIntent", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler { (call, result) in
        self.promise = result
        let args = call.arguments as? NSDictionary;
        switch call.method {
        case "stripeAddCard":
            self.addCard()
            break
        case "confirmSetupIntent":
            self.setupIntent(id: args!["paymentMethodId"] as! String, key: args!["clientSecret"] as! String)
            break
        case "nativePay":
            self.clientSecretKey = args!["clientSecret"] as! String
            self.applePay(sum: args!["amount"] as! Double)
            break
        default:
          break
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    @objc func applePay(sum: Double) {
        let merchantIdentifier = "merchant.com.javoh.takk"
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")

        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Takk, Inc", amount: NSDecimalNumber(value: sum)),
        ]
        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
            applePayContext.presentApplePay(on: controller, completion: nil)
        } else {
            self.promise(["err": "There is a problem with your Apple Pay configuration"])
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
      }
    
    private func setupIntent(id: String, key: String) {
        let setupIntentParams = STPSetupIntentConfirmParams(
                            clientSecret: key)
        setupIntentParams.returnURL = "stripejs://use_stripe_sdk/return_url"
                        setupIntentParams.paymentMethodID = id
        print("PARAM: " + id)
        print("PARAM: " + key)
        let paymentHandler = STPPaymentHandler.shared()
                paymentHandler.confirmSetupIntent(setupIntentParams, with: self) { status, setupIntent, error in
                    switch (status) {
                    case .failed:
                        print("BAG: " + error!.localizedDescription)
                        self.promise(["err": error?.localizedDescription])
                        break
                    case .canceled:
                        self.promise(["err": "Canceled"])
                        break
                    case .succeeded:
                        self.promise(["success": "Succeeded"])
                        break
                    @unknown default:
                        self.promise(["err": "Unknown error"])
                        break
                    }
                }
    }
    
    private func addCard() {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: addCardViewController)
        controller.present(navigationController, animated: true, completion: nil);
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        let map: NSDictionary = ["id": paymentMethod.stripeId , "last4": paymentMethod.card?.last4 ?? ""]
        self.promise(map)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func authenticationPresentingViewController() -> UIViewController {
        return controller
    }
    
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        let error = Error.self
        completion(self.clientSecretKey, error as? Error)
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
        print("PAY STATUS")
        print(status)
        switch status {
                case .success:
                    self.promise(["success": "Succeeded"])
                    break
                case .error:
                    self.promise(["err": "Error: " + error!.localizedDescription])
                    break
                case .userCancellation:
                    self.promise(["err": "Canceled"])
                    break
                @unknown default:
                    self.promise(["err": "Unknown error"])
                    fatalError()
                }
    }

}
