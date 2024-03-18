import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk_method_channel.dart';

void main() {
  MethodChannelFlutterNuveiSdk platform = MethodChannelFlutterNuveiSdk();
  const MethodChannel channel = MethodChannel('flutter_nuvei_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
