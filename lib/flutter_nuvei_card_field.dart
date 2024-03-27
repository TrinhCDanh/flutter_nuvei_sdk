import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk.dart';

class FlutterNuveiCardField extends StatefulWidget {
  const FlutterNuveiCardField({super.key});

  @override
  State<FlutterNuveiCardField> createState() => _FlutterNuveiCardFieldState();
}

class _FlutterNuveiCardFieldState extends State<FlutterNuveiCardField> {
  @override
  void initState() {
    FlutterNuveiSdk.onHandleNuveiField(
      onInputUpdated: (hasFocus) {
        print("onInputUpdated $hasFocus");
      },
      onInputValidated: (hasError) {
        print("onInputValidated $hasError");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'flutter_nuvei_fields';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }
}
