class TalkshowModel {
  int? id;
  String? category;
  String? title;
  String? description;
  String? youtubeUrl;
  int? status;
  String? createdAt;
  String? updatedAt;

  TalkshowModel(
      {required this.id,
      required this.category,
      required this.title,
      required this.description,
      required this.youtubeUrl,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  factory TalkshowModel.fromJson(Map<String, dynamic> json){
    return TalkshowModel(
      id: json['id'],
      category: json['category'],
      title: json['title'], 
      description: json['description'], 
      youtubeUrl: json['youtube_url'], 
      status: json['status'], 
      createdAt: json['created_at'], 
      updatedAt: json['updated_at']);
  }
}
