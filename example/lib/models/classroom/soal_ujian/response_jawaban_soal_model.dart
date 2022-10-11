class ResponseJawabanSoal <T> {
  int? code;
  String? status;
  String? message;
  T? data;

  ResponseJawabanSoal(
      {required this.code,
      required this.status,
      required this.message,
      required this.data});

  factory ResponseJawabanSoal.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) map) {
    return ResponseJawabanSoal<T>(
        code: json['code'],
        status: json['status'],
        message: json['message'],
        data: map(json['data'] ?? {}));
  }
}
