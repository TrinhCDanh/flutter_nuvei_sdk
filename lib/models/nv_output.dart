class NVOutput {
  String? cavv;
  String? eci;
  String? dsTransID;
  String? ccTempToken;
  String? transactionId;
  String? result;
  String? transactionStatus;
  String? errorDescription;
  String? status;
  String? token;
  String? error;
  int? errCode;

  NVOutput({
    this.cavv,
    this.eci,
    this.dsTransID,
    this.ccTempToken,
    this.transactionId,
    this.result,
    this.transactionStatus,
    this.errorDescription,
    this.errCode,
    this.status,
    this.token,
    this.error,
  });

  NVOutput.fromJson(Map<String, dynamic> json) {
    cavv = json['cavv'];
    eci = json['eci'];
    dsTransID = json['dsTransID'];
    ccTempToken = json['ccTempToken'];
    transactionId = json['transactionId'];
    result = json['result'];
    transactionStatus = json['transactionStatus'];
    errorDescription = json['errorDescription'];
    errCode = json['errCode'];
    status = json['status'];
    token = json['token'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cavv'] = cavv;
    data['eci'] = eci;
    data['dsTransID'] = dsTransID;
    data['ccTempToken'] = ccTempToken;
    data['transactionId'] = transactionId;
    data['result'] = result;
    data['transactionStatus'] = transactionStatus;
    data['errorDescription'] = errorDescription;
    data['errCode'] = errCode;
    data['status'] = status;
    data['token'] = token;
    data['error'] = error;
    return data;
  }
}
