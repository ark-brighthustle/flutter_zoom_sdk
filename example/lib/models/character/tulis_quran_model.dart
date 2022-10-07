class TulisQuranModel{
  int? id;
  String? status;

  TulisQuranModel({
    required this.id,
    required this.status,
  });

  factory TulisQuranModel.fromJson(Map<String?, dynamic> json) {
    return TulisQuranModel(
        id: json['id'],
        status: json['status']);
  }
}