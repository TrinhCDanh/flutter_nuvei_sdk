import 'package:flutter/material.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_card_field.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk.dart';

class MyNativeView extends StatelessWidget {
  const MyNativeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuvei Field example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FlutterNuveiCardField(
              width: 400,
              height: 260,
              onInputUpdated: (hasFocus) {
                print("onInputUpdated: $hasFocus");
              },
              onInputValidated: (hasError) {
                print("onInputValidated: $hasError");
              },
            ),
            GestureDetector(
              onTap: () async {
                final isError = await FlutterNuveiSdk.validateFields();
                print("Form error: $isError");
              },
              child: Container(
                width: 400,
                height: 50,
                color: Colors.amber,
                child: const Center(
                  child: Text("Submit"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
