import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNativeView extends StatelessWidget {
  const MyNativeView({super.key});

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'PaymentFragment';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Fragment Page'),
      ),
      body: AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
