class NVCheckoutInput {
  late final String sessionToken;
  late final String merchantId;
  late final String merchantSiteId;
  late final String currency;
  late final String amount;
  late final String userTokenId;
  late final String clientRequestId;
  late final String? customField1;
  late final String? customField2;
  late final String? customField3;

  NVCheckoutInput({
    required this.sessionToken,
    required this.merchantId,
    required this.merchantSiteId,
    required this.currency,
    required this.amount,
    required this.userTokenId,
    required this.clientRequestId,
    this.customField1,
    this.customField2,
    this.customField3,
  });

  NVCheckoutInput.fromJson(Map<String, dynamic> json) {
    sessionToken = json['sessionToken'];
    merchantId = json['merchantId'];
    merchantSiteId = json['merchantSiteId'];
    currency = json['currency'];
    amount = json['amount'];
    userTokenId = json['userTokenId'];
    clientRequestId = json['clientRequestId'];
    customField1 = json['customField1'];
    customField2 = json['customField2'];
    customField3 = json['customField3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionToken'] = sessionToken;
    data['merchantId'] = merchantId;
    data['merchantSiteId'] = merchantSiteId;
    data['currency'] = currency;
    data['amount'] = amount;
    data['userTokenId'] = userTokenId;
    data['clientRequestId'] = clientRequestId;
    data['customField1'] = customField1;
    data['customField2'] = customField2;
    data['customField3'] = customField3;
    return data;
  }
}
