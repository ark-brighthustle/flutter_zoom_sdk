class PenguatanKarakterTematikModel{
  int? id;
  int? category_id;
  String? title;
  String? created_at;
  String? video_url;
  String? description;
  String? category;

  PenguatanKarakterTematikModel({
    required this.id,
    required this.category_id,
    required this.title,
    required this.created_at,
    required this.video_url,
    required this.description,
    required this.category
  });

  factory PenguatanKarakterTematikModel.fromJson(Map<String?, dynamic> json) {
    return PenguatanKarakterTematikModel(
        id: json['id'],
        category_id: json['category_id'],
        title: json['title'],
        created_at: json['created_at'],
        video_url: json['video_url'],
        description: json['description'],
        category: json['category']);
  }
}