class NVTokenizeOutput {
  String? token;
  String? error;

  NVTokenizeOutput({
    required this.token,
    required this.error,
  });

  NVTokenizeOutput.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['error'] = error;
    return data;
  }
}
