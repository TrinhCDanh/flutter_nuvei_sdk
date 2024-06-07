import Flutter
import UIKit
import NuveiSimplyConnectSDK

public class FlutterNuveiSdkPlugin: NSObject, FlutterPlugin {
  var cardDataCallback: CardDataCallback?
  var creditCardField : NuveiCreditCardField?
  var cardNumberEditText: UITextField?
  var cardHolderNameEditText: UITextField?
  var expiryDateEditText: UITextField?
  var cvvEditText: UITextField?
  var applePayMerchantId: String = "merchant.com.nuveidigital.test"
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_nuvei_sdk", binaryMessenger: registrar.messenger())
    let instance = FlutterNuveiSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
      
    // Register the platform view
    instance.cardDataCallback = { creditCardField, cardNumber, cardHolderName, expiryDate, cvv in
        instance.creditCardField = creditCardField
        instance.cardNumberEditText = cardNumber
        instance.cardHolderNameEditText = cardHolderName
        instance.expiryDateEditText = expiryDate
        instance.cvvEditText = cvv
    }
    let factory = FLNativeViewFactory(
        messenger: registrar.messenger(),
        methodChannel: channel,
        cardDataCallback: instance.cardDataCallback
    )
    registrar.register(factory, withId: "flutter_nuvei_fields")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let viewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!;

    // Method Channel       
    switch call.method {
      case "setup":
        guard let args = call.arguments as? [String : Any] else {return}
        self.setup(result: result, args: args)
        break
      case "authenticate3d":
        guard let args = call.arguments as? [String : Any] else {return}
        self.authenticate3d(result: result, args: args, controller: viewController)
        break
      case "tokenize":
        guard let args = call.arguments as? [String : Any] else {return}
        self.tokenize(result: result, args: args)
        break
      case "checkout":
        guard let args = call.arguments as? [String : Any] else {return}
        self.checkout(result: result, args: args, controller: viewController)
        break
      case "validateFields":
        self.validateFields(result: result)
        break
      default:
        result(FlutterMethodNotImplemented)
        break
    }
  }
    
    /* Set environment */
     private func setup(result: FlutterResult, args: [String : Any]) {
       let environment = args["environment"] as! String
       // Nuvei field UI Customization
       let customization = NuveiFieldCustomization (
         labelCustomization: .init(
             textFont: UIFont.systemFont(ofSize: 12),
             textColor: UIColor(hex: "#49516F"),
             headingTextFont: UIFont.systemFont(ofSize: 12),
             headingTextColor: .white
         ),
         textBoxCustomization: .init (
             backgroundColor: .white,
             textFont: UIFont.systemFont(ofSize: 14),
             textColor: .black,
             borderColor: .black,
             cornerRadius: 0,
             borderWidth: 1
         ),
         errorLabelCustomization: .init (
             textFont: UIFont.systemFont(ofSize: 12),
             textColor: UIColor(hex: "#E02D3C")
         ),
         placeholderCustomization: .init (
             textFont: UIFont.systemFont(ofSize: 14),
             textColor: .gray
         ),
         backgroundColor: .white,
         borderColor: .white,
         cornerRadius: 0,
         borderWidth: 1
       )
         
       switch environment {
        case PackageEnvironment.stating:
            NuveiSimplyConnect.setup(environment: NuveiSimplyConnect.Environment.integration)
            NuveiFields.setup(environment: NuveiSimplyConnect.Environment.integration, customization: customization)
            applePayMerchantId = "merchant.com.nuveidigital.test"
            break
        default:
            NuveiSimplyConnect.setup(environment: NuveiSimplyConnect.Environment.production)
            NuveiFields.setup(environment: NuveiSimplyConnect.Environment.production, customization: customization)
            applePayMerchantId = "merchant.com.nuveidigital"
            break
       }
         
      result(true)
     }
    
     /* Authenticate 3D */
     private func authenticate3d(result: @escaping FlutterResult, args: [String : Any], controller: UIViewController) {
       let sessionToken = args["sessionToken"] as! String
       let merchantId = args["merchantId"] as! String
       let merchantSiteId = args["merchantSiteId"] as! String
       let currency = args["currency"] as! String
       let amount = args["amount"] as! String
       let cardHolderName = args["cardHolderName"] as! String
       let cardNumber = args["cardNumber"] as! String
       let cvv = args["cvv"] as! String
       let monthExpiry = args["monthExpiry"] as! String
       let yearExpiry = args["yearExpiry"] as! String
      
       let paymentOption = try! NVPaymentOption(
         card: NVCardDetails(
           cardNumber: cardNumber,
           cardHolderName: cardHolderName,
           cvv: cvv,
           expirationMonth: monthExpiry,
           expirationYear: yearExpiry
         )
       )
       let input = NVInput(
         sessionToken: sessionToken,
         merchantId: merchantId,
         applePayMerchantId: applePayMerchantId,
         merchantSiteId: merchantSiteId,
         currency: currency,
         amount: amount,
         paymentOption: paymentOption
       );
      
       // The viewController is used to present the challenge view controller(s) from
       NuveiSimplyConnect.authenticate3d(uiOwner: controller, input: input) { (output: NVAuthenticate3dOutput) in
         let authenticate3dResponse:Authenticate3dResponse = Authenticate3dResponse(
           cavv: output.cavv,
           eci: output.eci,
           dsTransID: output.dsTransID,
           ccTempToken: output.ccTempToken,
           transactionId: output.transactionId,
           result: output.result.rawValue.uppercased(),
           transactionStatus: output.rawResult?["transactionStatus"] as? String ?? "",
           errorDescription: output.errorDescription,
           errCode: output.errorCode,
           status: output.rawResult?["status"] as? String ?? ""
         )
         let authenticate3dResponseToJson = self.convertToJson(data: authenticate3dResponse)

         result(authenticate3dResponseToJson)
       }        
     }
    
    /* Tokenize */
    private func tokenize(result: @escaping FlutterResult, args: [String : Any]) {
      let sessionToken = args["sessionToken"] as! String
      let merchantId = args["merchantId"] as! String
      let merchantSiteId = args["merchantSiteId"] as! String
      let currency = "USD"
      let amount = "0"
      let cardHolderName = self.cardHolderNameEditText?.text
      let cardNumber = self.cardNumberEditText?.text
      let cvv = self.cvvEditText?.text
      let expiryDate = self.expiryDateEditText?.text
      let monthExpiry = String(expiryDate?.prefix(2) ?? "00")
      let yearExpiry = "20" + (expiryDate?.suffix(2) ?? "00")
     
      let paymentOption = try! NVPaymentOption(
        card: NVCardDetails(
          cardNumber: cardNumber,
          cardHolderName: cardHolderName,
          cvv: cvv,
          expirationMonth: monthExpiry,
          expirationYear: yearExpiry
        )
      )
      let input = NVInput(
        sessionToken: sessionToken,
        merchantId: merchantId,
        applePayMerchantId: applePayMerchantId,
        merchantSiteId: merchantSiteId,
        currency: currency,
        amount: amount,
        paymentOption: paymentOption
      );
           
      NuveiSimplyConnect.tokenize(input: input) { (token: String?, error: NVFailure?) in
        let tokenizeResponse:TokenizeResponse = TokenizeResponse(
          token: token,
          error: error?.description
        )
        let tokenizeResponseToJson = self.convertToJson(data: tokenizeResponse)
        result(tokenizeResponseToJson)
      }
    }
    
    private func validateFields(result: @escaping FlutterResult) {
        self.creditCardField!.validate() { error, errors in
            print(self.cardHolderNameEditText?.text ?? "")
            result(!(errors?.isEmpty ?? false))
        }
    }
    
    /* checkout */
    private func checkout(result: @escaping FlutterResult, args: [String : Any], controller: UIViewController) {
      let sessionToken = args["sessionToken"] as! String
      let merchantId = args["merchantId"] as! String
      let merchantSiteId = args["merchantSiteId"] as! String
      let currency = args["currency"] as! String
      let amount = args["amount"] as! String
      let userTokenId = args["userTokenId"] as! String
      let clientRequestId = args["clientRequestId"] as! String
      let firstName = args["firstName"] as! String
      let lastName = args["lastName"] as! String
      let country = args["country"] as! String
      let email = args["email"] as! String
      let customField1 = args["customField1"] as? String
      let customField2 = args["customField2"] as? String
      let customField3 = args["customField3"] as? String
      let customField4 = args["customField4"] as? String
      let customField5 = args["customField5"] as? String
      let customField6 = args["customField6"] as? String
      let customField7 = args["customField7"] as? String
        
            
      let input = NVInput(
        sessionToken: sessionToken,
        merchantId: merchantId,
        applePayMerchantId: applePayMerchantId,
        merchantSiteId: merchantSiteId,
        currency: currency,
        amount: amount,
        paymentOption:  try! NVPaymentOption(
            card: NVCardDetails()
        ),
        userTokenId: userTokenId,
        clientRequestId: clientRequestId,
        billingAddress: NVBillingAddress(
            firstName: firstName,
            lastName: lastName,
            country: country,
            email: email
        ),
        merchantDetails: NVMerchantDetails(
            customField1: customField1,
            customField2: customField2,
            customField3: customField3,
            customField4: customField4,
            customField5: customField5,
            customField6: customField6,
            customField7: customField7
        )
      );
                 
      NuveiSimplyConnect.checkout(
        uiOwner: controller,
        authenticate3dInput: input,
        forceWebChallenge: true
      ) { (output: NuveiSimplyConnectSDK.NVCreatePaymentOutput) in
          let checkoutResponse:CheckoutResponse = CheckoutResponse(
            result: output.result.rawValue.uppercased(),
            errCode: output.errorCode,
            errorDescription: output.errorDescription
          )
          let checkoutResponseToJson = self.convertToJson(data: checkoutResponse)
          result(checkoutResponseToJson)
      } declineFallbackDecision: { response, viewController, declineFallback in
          let checkoutResponse:CheckoutResponse = CheckoutResponse(
            result: response.result.rawValue.uppercased(),
            errCode: response.errorCode,
            errorDescription: response.errorDescription
          )
          let checkoutResponseToJson = self.convertToJson(data: checkoutResponse)
          result(checkoutResponseToJson)
          viewController.dismiss(animated: true)
      }
    }
           
    // utils function
    private func convertToJson<T: Encodable>(data: T) -> String {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted

      let data = try! encoder.encode(data)
      print(String(data: data, encoding: .utf8)!)
      
      return String(data: data, encoding: .utf8)!
    }  
}

enum PackageEnvironment {
  static let stating = "STAGING"
  static let production = "PRODUCTION"
}

struct Authenticate3dResponse: Codable {
  var cavv: String?
  var eci: String?
  var dsTransID: String?
  var ccTempToken: String?
  var transactionId: String?
  var result: String?
  var transactionStatus: String?
  var errorDescription: String?
  var errCode: Int?
  var status: String?
}

struct TokenizeResponse: Codable {
  var token: String?
  var error: String?
}

struct CheckoutResponse: Codable {
  var result: String?
  var errCode: Int?
  var errorDescription: String?
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

typealias CardDataCallback = (
    _ creditCardField : NuveiCreditCardField,
    _ cardNumber: UITextField,
    _ cardHolderName: UITextField,
    _ expiryDate: UITextField,
    _ cvv: UITextField
) -> Void



