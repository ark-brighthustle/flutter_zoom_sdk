class EventClickModel{
  int? code;
  String? status;
  String? message;

  EventClickModel(
      {required this.code,
        required this.status,
        required this.message});

  factory EventClickModel.fromJson(Map<String, dynamic> json) {
    return EventClickModel(
        code: json['code'],
        status: json['status'],
        message: json['message']);
  }
}