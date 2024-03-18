import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_nuvei_sdk/data/enums.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk.dart';
import 'package:flutter_nuvei_sdk/models/nv_authenticate3d_input.dart';
import 'package:flutter_nuvei_sdk/models/nv_authenticate3d_output.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializer();
  }

  Future<void> initializer() async {
    try {
      await FlutterNuveiSdk.setup(NVEnvironmentEnum.staging);
    } on PlatformException {
      print("initializer error");
    }
  }

  Future<void> authenticate3d() async {
    try {
      final NVAuthenticate3dInput input = NVAuthenticate3dInput(
        sessionToken: "9c7cfc1c-33bb-410d-a700-6b9680a68e93",
        merchantId: '4099004892638267996',
        merchantSiteId: '250858',
        currency: 'USD',
        amount: "151",
        cardHolderName: "CL-BRW2",
        cardNumber: "2221008123677736",
        cvv: "999",
        monthExpiry: "2",
        yearExpiry: "2025",
      );
      final NVAuthenticate3dOutput? resultAuthenticate3d =
          await FlutterNuveiSdk.authenticate3d(input);
      print("=================");
      print(resultAuthenticate3d);
      print("=================");
    } on PlatformException {
      print("authenticate3d error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nuvei Payment example app'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: authenticate3d,
                child: Container(
                  color: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: const Text('authenticate3d()'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
