import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_nuvei_sdk_platform_interface.dart';

/// An implementation of [NuveiPaymentWrapperPlatform] that uses method channels.
class MethodChannelFlutterNuveiSdk extends FlutterNuveiSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_nuvei_sdk');

  @override
  Future<bool?> setup(Map<String, dynamic> args) async {
    return await methodChannel.invokeMethod<bool>('setup', args);
  }

  @override
  Future<String?> authenticate3d(Map<String, dynamic> args) async {
    final data =
        await methodChannel.invokeMethod<String>('authenticate3d', args);
    return data;
  }

  @override
  Future<String?> tokenize(Map<String, dynamic> args) async {
    final data = await methodChannel.invokeMethod<String>('tokenize', args);
    return data;
  }

  @override
  Future<String?> checkout(Map<String, dynamic> args) async {
    final data = await methodChannel.invokeMethod<String>('checkout', args);
    return data;
  }

  @override
  Future<bool> validateFields() async {
    final data = await methodChannel.invokeMethod<bool>('validateFields');
    return data ?? false;
  }

  @override
  Future<void> onHandleNuveiField({
    required Function(bool) onInputUpdated,
    required Function(bool) onInputValidated,
  }) async {
    methodChannel.setMethodCallHandler((handler) async {
      switch (handler.method) {
        case 'onInputUpdated':
          final String dataFromKotlin = handler.arguments as String;
          onInputUpdated(dataFromKotlin.toLowerCase() != "false");
          break;
        case 'onInputValidated':
          final String dataFromKotlin = handler.arguments as String;
          onInputValidated(dataFromKotlin.toLowerCase() != "false");
          break;
        default:
          throw UnimplementedError("Method ${handler.method} not implemented");
      }
    });
  }
}
