import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk.dart';

class MyNativeView extends StatefulWidget {
  const MyNativeView({super.key});

  @override
  State<MyNativeView> createState() => _MyNativeViewState();
}

class _MyNativeViewState extends State<MyNativeView> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuvei Field example'),
      ),
      body: SizedBox(
        width: 400,
        height: 400,
        child: AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      ),
    );
  }
}
