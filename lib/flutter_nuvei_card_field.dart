import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk.dart';

class FlutterNuveiCardField extends StatefulWidget {
  final double width;
  final double height;
  final Function(bool)? onInputUpdated;
  final Function(bool)? onInputValidated;

  const FlutterNuveiCardField({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onInputUpdated,
    this.onInputValidated,
  });

  @override
  State<FlutterNuveiCardField> createState() => _FlutterNuveiCardFieldState();
}

class _FlutterNuveiCardFieldState extends State<FlutterNuveiCardField> {
  @override
  void initState() {
    FlutterNuveiSdk.onHandleNuveiField(
      onInputUpdated: (hasFocus) {
        if (widget.onInputUpdated != null) {
          widget.onInputUpdated!(hasFocus);
        }
      },
      onInputValidated: (hasError) {
        if (widget.onInputValidated != null) {
          widget.onInputValidated!(hasError);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _renderPlatform(),
    );
  }

  Widget _renderPlatform() {
    // This is used in the platform side to register the view.
    const String viewType = 'flutter_nuvei_fields';
    // Pass parameters to the platform side.

    if (Platform.isAndroid) {
      final Map<String, dynamic> creationParams = <String, dynamic>{};
      return AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      final Map<String, dynamic> creationParams = <String, dynamic>{
        'containerWidth': widget.width,
      };
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }
}
