import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk_platform_interface.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNuveiSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNuveiSdkPlatform {
  @override
  Future<String?> authenticate3d(Map<String, dynamic> args) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> setup(String environment) {
    throw UnimplementedError();
  }

  @override
  Future<String?> tokenize(Map<String, dynamic> args) {
    throw UnimplementedError();
  }

  @override
  Future<String?> checkout(Map<String, dynamic> args) {
    throw UnimplementedError();
  }

  @override
  Future<void> onHandleNuveiField({
    required Function(bool p1) onInputUpdated,
    required Function(bool p1) onInputValidated,
  }) async {
    // TODO: implement onHandleNuveiField
  }
}

void main() {
  final FlutterNuveiSdkPlatform initialPlatform =
      FlutterNuveiSdkPlatform.instance;

  test('$MethodChannelFlutterNuveiSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNuveiSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterNuveiSdk flutterNuveiSdkPlugin = FlutterNuveiSdk();
    MockFlutterNuveiSdkPlatform fakePlatform = MockFlutterNuveiSdkPlatform();
    FlutterNuveiSdkPlatform.instance = fakePlatform;
  });
}
