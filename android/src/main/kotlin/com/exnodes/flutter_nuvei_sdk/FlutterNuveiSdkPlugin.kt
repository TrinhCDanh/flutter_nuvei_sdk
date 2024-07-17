package com.exnodes.flutter_nuvei_sdk

import android.app.Activity
import android.content.Context
import com.google.gson.Gson
import android.util.Log
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.TextView
import androidx.annotation.NonNull
import com.nuvei.sdk.Callback
import com.nuvei.sdk.Error

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.nuvei.sdk.NuveiSimplyConnect
import com.nuvei.sdk.TokenizeCallback
import com.nuvei.sdk.model.*
import com.nuvei.sdk.views.nuveifields.NuveiCreditCardField
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterNuveiSdkPlugin */
class FlutterNuveiSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var creditCardField : NuveiCreditCardField
  private lateinit var cardNumberEditText: EditText
  private lateinit var cardHolderNameEditText: EditText
  private lateinit var expiryDateEditText: EditText
  private lateinit var cvvEditText: EditText
  private val gson = Gson()
  private lateinit var googlePayMerchantId: String
  private lateinit var googlePayMerchantName: String
  private lateinit var googlePayGateway: String
  private lateinit var googlePayGatewayMerchantId: String


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_nuvei_sdk")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext

    // Register PlatformViewFactory here
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      "flutter_nuvei_fields",
      NativeViewFactory(channel, object : CardDataCallback {
        override fun invoke(creditCardField : NuveiCreditCardField, cardNumber: EditText, cardHolderName: EditText, expiryDate: EditText, cvv: EditText) {
          this@FlutterNuveiSdkPlugin.creditCardField = creditCardField
          cardNumberEditText = cardNumber
          cardHolderNameEditText = cardHolderName
          expiryDateEditText = expiryDate
          cvvEditText = cvv
        }
      })
    )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "setup" -> {
        setup(result, call)
      }
      "authenticate3d" -> {
        authenticate3d(result, call)
      }
      "tokenize" -> {
        tokenize(result, call)
      }
      "checkout" -> {
        checkout(result, call)
      }
      "validateFields" -> {
        validateFields(result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun setup(result: MethodChannel.Result, call: MethodCall) {
    // Set environment
    val environment: String = call.argument("environment")!!
    googlePayMerchantId = call.argument("googlePayMerchantId")!!
    googlePayMerchantName = call.argument("googlePayMerchantName")!!
    googlePayGateway = call.argument("googlePayGateway")!!
    googlePayGatewayMerchantId = call.argument("googlePayGatewayMerchantId")!!

    when (environment) {
      PackageEnvironment.stating -> {
        NuveiSimplyConnect.setup(
          environment = NuveiSimplyConnect.Environment.STAGING,
        );
      }
      else -> {
        NuveiSimplyConnect.setup(
          environment = NuveiSimplyConnect.Environment.PROD,
        );
      }
    }

    result.success(true)
  }

  private fun authenticate3d(result: MethodChannel.Result, call: MethodCall) {
    val sessionToken: String = call.argument("sessionToken")!!
    val merchantId: String = call.argument("merchantId")!!
    val merchantSiteId: String = call.argument("merchantSiteId")!!
    val currency: String = call.argument("currency")!!
    val amount: String = call.argument("amount")!!
    val cardHolderName: String = call.argument("cardHolderName")!!
    val cardNumber: String = call.argument("cardNumber")!!
    val cvv: String = call.argument("cvv")!!
    val monthExpiry: String = call.argument("monthExpiry")!!
    val yearExpiry: String = call.argument("yearExpiry")!!

    val paymentOption = PaymentOption(
      card = CardDetails(
        cardNumber,
        cardHolderName,
        cvv,
        monthExpiry,
        yearExpiry,
      ),
    )

    val input = NVPayment(
      sessionToken,
      merchantId,
      merchantSiteId,
      googlePayMerchantId,
      googlePayMerchantName,
      googlePayGateway,
      googlePayGatewayMerchantId,
      currency,
      amount,
      paymentOption = paymentOption,
    )

    NuveiSimplyConnect.authenticate3d(
      activity = activity,
      input = input,
      callback = object : Callback<NVAuthenticate3dOutput> {
        override fun onComplete(response: NVAuthenticate3dOutput) {
           writeToLog(gson.toJson(response))
          val authenticate3dResponse = Authenticate3dResponse(
            cavv = response.cavv,
            eci =  response.eci,
            dsTransID = response.dsTransID,
            ccTempToken =  response.ccTempToken,
            transactionId = response.transactionId,
            result = response.result.uppercase(),
            transactionStatus = response.rawResult?.get("transactionStatus") as String?,
            errorDescription = response.errorDescription,
            errCode = response.errorCode,
            status = response.rawResult?.get("status") as String?
          )
          val authenticate3dResponseToJson = gson.toJson(authenticate3dResponse)
          result.success(authenticate3dResponseToJson)
        }
      }
    )
  }

  private fun tokenize(result: MethodChannel.Result, call: MethodCall) {
    val sessionToken: String = call.argument("sessionToken")!!
    val merchantId: String = call.argument("merchantId")!!
    val merchantSiteId: String = call.argument("merchantSiteId")!!
    val currency: String = "USD"
    val amount: String = "0"
    val cardHolderName: String = cardNumberEditText.text.toString()
    val cardNumber: String = cardNumberEditText.text.toString()
    val cvv: String = cvvEditText.text.toString()
    val expiryDate = expiryDateEditText.text
    val monthExpiry: String = expiryDate.substring(0, 2)
    val yearExpiry: String = "20${expiryDate.substring(2)}"

    val paymentOption = PaymentOption(
      card = CardDetails(
        cardNumber,
        cardHolderName,
        cvv,
        monthExpiry,
        yearExpiry,
      ),
    )

    val input = NVPayment(
      sessionToken,
      merchantId,
      merchantSiteId,
      googlePayMerchantId,
      googlePayMerchantName,
      googlePayGateway,
      googlePayGatewayMerchantId,
      currency,
      amount,
      paymentOption = paymentOption,
    )

    NuveiSimplyConnect.tokenize(
      activity = activity,
      input = input,
      callback = object : TokenizeCallback {
        override fun onComplete(token: String?, error: Error?, additionalInfo: Map<String, Any>?) {
          writeToLog(gson.toJson(additionalInfo))
          val tokenizeResponse = TokenizeResponse(
            token = token,
            error = error?.name
          )
          val tokenizeResponseToJson = gson.toJson(tokenizeResponse)
          result.success(tokenizeResponseToJson)
        }
      }
    )
  }

  private fun validateFields(result: MethodChannel.Result) {
    // Un-focus and dismiss keyboard
    cardNumberEditText.clearFocus()
    cardHolderNameEditText.clearFocus()
    expiryDateEditText.clearFocus()
    cvvEditText.clearFocus()

    val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    imm.hideSoftInputFromWindow(cardNumberEditText.windowToken, 0)
    imm.hideSoftInputFromWindow(cardHolderNameEditText.windowToken, 0)
    imm.hideSoftInputFromWindow(expiryDateEditText.windowToken, 0)
    imm.hideSoftInputFromWindow(cvvEditText.windowToken, 0)

    // Validate fields
    creditCardField.validate()
    val numberErrorTextView = creditCardField.findViewById<TextView>(R.id.numberErrorTextView)
    val cardHolderNameErrorTextView = creditCardField.findViewById<TextView>(R.id.holderNameErrorTextView)
    val expiryDateErrorTextView = creditCardField.findViewById<TextView>(R.id.expiryErrorTextView)
    val cvvErrorTextView = creditCardField.findViewById<TextView>(R.id.cvvErrorTextView)
    val hasError: Boolean = numberErrorTextView.text.isNotEmpty() || cardHolderNameErrorTextView.text.isNotEmpty() || expiryDateErrorTextView.text.isNotEmpty() || cvvErrorTextView.text.isNotEmpty()
    result.success(hasError)
  }
  private fun checkout(result: MethodChannel.Result, call: MethodCall) {
    val sessionToken: String = call.argument("sessionToken")!!
    val merchantId: String = call.argument("merchantId")!!
    val merchantSiteId: String = call.argument("merchantSiteId")!!
    val currency: String = call.argument("currency")!!
    val amount: String = call.argument("amount")!!
    val userTokenId: String = call.argument("userTokenId")!!
    val clientRequestId: String = call.argument("clientRequestId")!!
    val firstName: String = call.argument("firstName")!!
    val lastName: String = call.argument("lastName")!!
    val country: String = call.argument("country")!!
    val email: String = call.argument("email")!!
    val customField1: String? = call.argument("customField1")
    val customField2: String? = call.argument("customField2")
    val customField3: String? = call.argument("customField3")
    val customField4: String? = call.argument("customField4")
    val customField5: String? = call.argument("customField5")
    val customField6: String? = call.argument("customField6")
    val customField7: String? = call.argument("customField7")

    val input = NVPayment(
      sessionToken,
      merchantId,
      merchantSiteId,
      googlePayMerchantId,
      googlePayMerchantName,
      googlePayGateway,
      googlePayGatewayMerchantId,
      currency,
      amount,
      PaymentOption(),
      userTokenId,
      clientRequestId,
      billingAddress = BillingAddress(
        firstName = firstName,
        lastName = lastName,
        country = country,
        email = email,
      ),
      merchantDetails = MerchantDetails(
        customField1,
        customField2,
        customField3,
        customField4,
        customField5,
        customField6,
        customField7,
      ),
      countryCode = country,
    )

    NuveiSimplyConnect.checkout(
      activity = activity,
      input = input,
      forceWebChallenge = true,
      callback = object : Callback<NVOutput> {
        override fun onComplete(response: NVOutput) {
          writeToLog(gson.toJson(response))
          val checkoutResponse = CheckoutResponse(
            result = response.result.uppercase(),
            errCode = response.errorCode,
            errorDescription = response.errorDescription
          )
          val checkoutResponseToJson = gson.toJson(checkoutResponse)
          result.success(checkoutResponseToJson)
        }
      }
    ) { response, activity, declineFallback ->
      writeToLog(gson.toJson(response))
      val checkoutResponse = CheckoutResponse(
        result = response.result.uppercase(),
        errCode = response.errorCode,
        errorDescription = response.errorDescription
      )
      val checkoutResponseToJson = gson.toJson(checkoutResponse)
      result.success(checkoutResponseToJson)
      declineFallback(NuveiSimplyConnect.CheckoutCompletionAction.dismiss)
    }
  }

  private fun writeToLog(log: String) {
    Log.d("print", log)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
}

class PackageEnvironment {
  companion object {
    const val stating = "STAGING"
    const val production = "PRODUCTION"
  }
}

data class Authenticate3dResponse(
  val cavv: String?,
  val eci: String?,
  val dsTransID: String?,
  val ccTempToken: String?,
  val transactionId: String?,
  val result: String?,
  val transactionStatus: String?,
  val errorDescription: String?,
  val errCode: Int?,
  val status: String?,
)

data class TokenizeResponse(
  val token: String?,
  val error: String?,
)

data class CheckoutResponse(
  val result: String?,
  val errCode: Int?,
  val errorDescription: String?,
)

typealias CardDataCallback = (
  creditCardField : NuveiCreditCardField,
  cardNumber: EditText,
  cardHolderName: EditText,
  expiryDate: EditText,
  cvv: EditText
) -> Unit