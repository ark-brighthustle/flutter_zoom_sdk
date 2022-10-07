class AmaliahPersonalModel <T> {
  bool? success;
  String? message;
  T? data;

  AmaliahPersonalModel(
      {required this.success,
      required this.message,
      required this.data});

  factory AmaliahPersonalModel.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) build) {
    return AmaliahPersonalModel<T>(
      success: json['success'],
      message: json['message'],
      data: build(json['data'] ?? {}));
  }
}
