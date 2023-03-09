class VaksinSiswaModel <T> {
  bool? success;
  int? code;
  String? message;
  T? data;

  VaksinSiswaModel(
      {required this.success,
      required this.code,
      required this.message,
      required this.data});

  factory VaksinSiswaModel.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) build) {
    return VaksinSiswaModel<T>(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: build(json['data'] ?? {}));
  }
}
