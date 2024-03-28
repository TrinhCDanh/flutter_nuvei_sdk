class NVTokenizeInput {
  late final String sessionToken;
  late final String merchantId;
  late final String merchantSiteId;

  NVTokenizeInput({
    required this.sessionToken,
    required this.merchantId,
    required this.merchantSiteId,
  });

  NVTokenizeInput.fromJson(Map<String, dynamic> json) {
    sessionToken = json['sessionToken'];
    merchantId = json['merchantId'];
    merchantSiteId = json['merchantSiteId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionToken'] = sessionToken;
    data['merchantId'] = merchantId;
    data['merchantSiteId'] = merchantSiteId;
    return data;
  }
}
