class ResponseJawabanSoalUjianModel <T> {
  int? code;
  String? status;
  String? message;
  T? data;

  ResponseJawabanSoalUjianModel(
      {required this.code,
      required this.status,
      required this.message,
      required this.data});

  factory ResponseJawabanSoalUjianModel.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) map) {
    return ResponseJawabanSoalUjianModel<T>(
        code: json['code'],
        status: json['status'],
        message: json['message'],
        data: map(json['data'] ?? {}));
  }
}
