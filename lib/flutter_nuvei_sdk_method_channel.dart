import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_nuvei_sdk_platform_interface.dart';

/// An implementation of [NuveiPaymentWrapperPlatform] that uses method channels.
class MethodChannelFlutterNuveiSdk extends FlutterNuveiSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_nuvei_sdk');

  @override
  Future<bool?> setup(String environment) async {
    return await methodChannel
        .invokeMethod<bool>('setup', {"environment": environment});
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
}
