class UpdateAppModel {
  int? id;
  int? version;
  String? versionTitle;
  String? comment;
  String? url;
  String? createdAt;
  String? updatedAt;

  UpdateAppModel({
    required this.id,
    required this.version,
    required this.versionTitle,
    required this.comment,
    required this.url,
    required this.createdAt,
    required this.updatedAt
  });

  factory UpdateAppModel.fromJson(Map<String, dynamic> json) {
    return UpdateAppModel(
      id: json['id'], 
      version: json['version'], 
      versionTitle: json['version_title'], 
      comment: json['comment'], 
      url: json['url'], 
      createdAt: json['created_at'], 
      updatedAt: json['updated_at']);
  }
}