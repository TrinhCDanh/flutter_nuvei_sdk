import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nuvei_sdk/flutter_nuvei_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String sessionToken = "";
  final String merchantId = "";
  final String merchantSiteId = "";
  final String currency = 'USD';
  final String amount = "151";
  final String cardHolderName = "CL-BRW2";
  final String cardNumber = "2221008123677736";
  final String cvv = "999";
  final String monthExpiry = "12";
  final String yearExpiry = "2026";
  final String userTokenId = "117";
  final String clientRequestId = "20240325134325";

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
        sessionToken: sessionToken,
        merchantId: merchantId,
        merchantSiteId: merchantSiteId,
        currency: currency,
        amount: amount,
        cardHolderName: cardHolderName,
        cardNumber: cardNumber,
        cvv: cvv,
        monthExpiry: monthExpiry,
        yearExpiry: yearExpiry,
      );
      final NVOutput? resultAuthenticate3d =
          await FlutterNuveiSdk.authenticate3d(input);
      print("=================");
      print(resultAuthenticate3d);
      print("=================");
    } on PlatformException {
      print("authenticate3d error");
    }
  }

  Future<void> tokenize() async {
    try {
      final NVTokenizeInput input = NVTokenizeInput(
        sessionToken: sessionToken,
        merchantId: merchantId,
        merchantSiteId: merchantSiteId,
        cardHolderName: cardHolderName,
        cardNumber: cardNumber,
        cvv: cvv,
        monthExpiry: monthExpiry,
        yearExpiry: yearExpiry,
      );
      final NVOutput? resultTokenize = await FlutterNuveiSdk.tokenize(input);
      print("=================");
      print(resultTokenize);
      print("=================");
    } on PlatformException {
      print("tokenize error");
    }
  }

  Future<void> checkout(context) async {
    try {
      final NVCheckoutInput input = NVCheckoutInput(
        sessionToken: sessionToken,
        merchantId: merchantId,
        merchantSiteId: merchantSiteId,
        currency: currency,
        amount: amount,
        userTokenId: userTokenId,
        clientRequestId: clientRequestId,
      );
      final NVOutput? resultCheckout = await FlutterNuveiSdk.checkout(input);
      print("=================");
      print(resultCheckout);
      print("=================");
    } on PlatformException {
      print("checkout error");
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
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: tokenize,
                child: Container(
                  color: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: const Text('tokenize()'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => checkout(context),
                child: Container(
                  color: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: const Text('checkout()'),
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   height: 300,
              //   child: const FlutterNuveiCardField(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
