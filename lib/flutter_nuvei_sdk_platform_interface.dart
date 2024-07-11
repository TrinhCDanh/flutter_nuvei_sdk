import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_nuvei_sdk_method_channel.dart';

abstract class FlutterNuveiSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterNuveiSdkPlatform.
  FlutterNuveiSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNuveiSdkPlatform _instance = MethodChannelFlutterNuveiSdk();

  /// The default instance of [FlutterNuveiSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNuveiSdk].
  static FlutterNuveiSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNuveiSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterNuveiSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> setup(Map<String, dynamic> args) {
    throw UnimplementedError('setup() has not been implemented.');
  }

  Future<String?> authenticate3d(Map<String, dynamic> args) {
    throw UnimplementedError('authenticate3d() has not been implemented.');
  }

  Future<String?> tokenize(Map<String, dynamic> args) {
    throw UnimplementedError('tokenize() has not been implemented.');
  }

  Future<String?> checkout(Map<String, dynamic> args) {
    throw UnimplementedError('checkout() has not been implemented.');
  }

  Future<bool> validateFields() {
    throw UnimplementedError('validateFields() has not been implemented.');
  }

  Future<void> onHandleNuveiField({
    required Function(bool) onInputUpdated,
    required Function(bool) onInputValidated,
  }) {
    throw UnimplementedError('onHandleNuveiField() has not been implemented.');
  }
}
