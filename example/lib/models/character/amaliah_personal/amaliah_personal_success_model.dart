class AmaliahPersonalSuccessModel <T> {
  int? id;
  String? topic;
  String? description;
  String? created_at;
  String? file;
  String? file_type;

  AmaliahPersonalSuccessModel({
    required this.id,
    required this.topic,
    required this.description,
    required this.created_at,
    required this.file,
    required this.file_type
  });

  factory AmaliahPersonalSuccessModel.fromJson(Map<String, dynamic> json) {
    return AmaliahPersonalSuccessModel(
        id: json['id'],
        topic: json['topic'],
        description: json['description'],
        created_at: json['created_at'],
        file: json['file'],
        file_type: json['file_type']);
  }
}
