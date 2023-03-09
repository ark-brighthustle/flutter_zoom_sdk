class PodcastModel {
  int? id;
  String? title;
  String? description;
  String? youtubeUrl;
  int? status;
  String? createdAt;
  String? updatedAt;

  PodcastModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.youtubeUrl,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  factory PodcastModel.fromJson(Map<String, dynamic> json){
    return PodcastModel(
      id: json['id'],
      title: json['title'], 
      description: json['description'], 
      youtubeUrl: json['youtube_url'], 
      status: json['status'], 
      createdAt: json['created_at'], 
      updatedAt: json['updated_at']);
  }
}
