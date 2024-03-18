package com.exnodes.flutter_nuvei_sdk

import android.app.Activity
import android.content.Context
import com.google.gson.Gson
import android.util.Log
import androidx.annotation.NonNull
import com.nuvei.sdk.Callback

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.nuvei.sdk.NuveiSimplyConnect
import com.nuvei.sdk.model.*
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
  private val gson = Gson()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_nuvei_sdk")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
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
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun setup(result: MethodChannel.Result, call: MethodCall) {
    // Set environment
    val environment: String = call.argument("environment")!!
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

  private fun writeToLog(log: String) {
    Log.d("print", log)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
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
