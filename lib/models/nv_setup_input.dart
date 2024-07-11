class NVSetupInput {
  late String environment;
  late String googlePayMerchantId;
  late String googlePayMerchantName;
  late String googlePayGateway;
  late String googlePayGatewayMerchantId;
  late String applePayMerchantId;

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
