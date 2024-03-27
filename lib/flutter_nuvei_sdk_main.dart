import 'dart:convert';
import 'package:flutter_nuvei_sdk/data/constants.dart';
import 'package:flutter_nuvei_sdk/data/enums.dart';
import 'package:flutter_nuvei_sdk/models/nv_authenticate3d_input.dart';
import 'package:flutter_nuvei_sdk/models/nv_checkout_input.dart';
import 'package:flutter_nuvei_sdk/models/nv_output.dart';
import 'package:flutter_nuvei_sdk/models/nv_tokenize_input.dart';
import 'flutter_nuvei_sdk_platform_interface.dart';

class FlutterNuveiSdk {
  // Check SDK init success or fail
  static bool isReady = false;

  static Future<void> setup(NVEnvironmentEnum environment) async {
    isReady = await FlutterNuveiSdkPlatform.instance
            .setup(nvEnvironmentText[environment]) ??
        false;
  }

  static Future<NVOutput?> authenticate3d(
    NVAuthenticate3dInput input,
  ) async {
    final Map<String, dynamic> args = input.toJson();
    final String? output =
        await FlutterNuveiSdkPlatform.instance.authenticate3d(args);

    if (output == null) {
      return null;
    }

    final Map<String, dynamic> outputToJson = jsonDecode(output);
    return NVOutput.fromJson(outputToJson);
  }

  static Future<NVOutput?> tokenize(
    NVTokenizeInput input,
  ) async {
    final Map<String, dynamic> args = input.toJson();
    final String? output =
        await FlutterNuveiSdkPlatform.instance.tokenize(args);

    if (output == null) {
      return null;
    }

    final Map<String, dynamic> outputToJson = jsonDecode(output);
    return NVOutput.fromJson(outputToJson);
  }

  static Future<NVOutput?> checkout(
    NVCheckoutInput input,
  ) async {
    final Map<String, dynamic> args = input.toJson();
    final String? output =
        await FlutterNuveiSdkPlatform.instance.checkout(args);

    if (output == null) {
      return null;
    }

    final Map<String, dynamic> outputToJson = jsonDecode(output);
    return NVOutput.fromJson(outputToJson);
  }

  static Future<void> onHandleNuveiField({
    required Function(bool) onInputUpdated,
    required Function(bool) onInputValidated,
  }) async {
    await FlutterNuveiSdkPlatform.instance.onHandleNuveiField(
      onInputUpdated: onInputUpdated,
      onInputValidated: onInputValidated,
    );
  }

  static final FlutterNuveiSdk _instance = FlutterNuveiSdk._internal();
  factory FlutterNuveiSdk() {
    return _instance;
  }
  FlutterNuveiSdk._internal();
}
