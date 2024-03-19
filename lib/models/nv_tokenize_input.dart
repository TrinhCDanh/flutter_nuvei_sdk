class NVTokenizeInput {
  late final String sessionToken;
  late final String merchantId;
  late final String merchantSiteId;
  late final String cardHolderName;
  late final String cardNumber;
  late final String cvv;
  late final String monthExpiry;
  late final String yearExpiry;

  NVTokenizeInput({
    required this.sessionToken,
    required this.merchantId,
    required this.merchantSiteId,
    required this.cardHolderName,
    required this.cardNumber,
    required this.cvv,
    required this.monthExpiry,
    required this.yearExpiry,
  });

  NVTokenizeInput.fromJson(Map<String, dynamic> json) {
    sessionToken = json['sessionToken'];
    merchantId = json['merchantId'];
    merchantSiteId = json['merchantSiteId'];
    cardHolderName = json['cardHolderName'];
    cardNumber = json['cardNumber'];
    cvv = json['cvv'];
    monthExpiry = json['monthExpiry'];
    yearExpiry = json['yearExpiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionToken'] = sessionToken;
    data['merchantId'] = merchantId;
    data['merchantSiteId'] = merchantSiteId;
    data['cardHolderName'] = cardHolderName;
    data['cardNumber'] = cardNumber;
    data['cvv'] = cvv;
    data['monthExpiry'] = monthExpiry;
    data['yearExpiry'] = yearExpiry;
    return data;
  }
}
