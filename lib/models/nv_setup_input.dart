import 'package:flutter_nuvei_sdk/data/enums.dart';

class NVSetupInput {
  late final NVEnvironmentEnum environment;
  late final String googlePayMerchantId;
  late final String googlePayMerchantName;
  late final String googlePayGateway;
  late final String googlePayGatewayMerchantId;
  late final String applePayMerchantId;

  NVSetupInput({
    required this.environment,
    required this.googlePayMerchantId,
    required this.googlePayMerchantName,
    required this.googlePayGateway,
    required this.googlePayGatewayMerchantId,
    required this.applePayMerchantId,
  });

  NVSetupInput.fromJson(Map<String, dynamic> json) {
    environment = json['environment'];
    googlePayMerchantId = json['googlePayMerchantId'];
    googlePayMerchantName = json['googlePayMerchantName'];
    googlePayGateway = json['googlePayGateway'];
    googlePayGatewayMerchantId = json['googlePayGatewayMerchantId'];
    applePayMerchantId = json['applePayMerchantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['environment'] = environment;
    data['googlePayMerchantId'] = googlePayMerchantId;
    data['googlePayMerchantName'] = googlePayMerchantName;
    data['googlePayGateway'] = googlePayGateway;
    data['googlePayGatewayMerchantId'] = googlePayGatewayMerchantId;
    data['applePayMerchantId'] = applePayMerchantId;
    return data;
  }
}
