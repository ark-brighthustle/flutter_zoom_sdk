class JuaraKompetisiModel {
  int? id;
  String? title;
  String? thumbnail;
  String? video;

  JuaraKompetisiModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.video
  });

  factory JuaraKompetisiModel.fromJson(Map<String, dynamic> json) {
    return JuaraKompetisiModel(
      id: json['id'], 
      title: json['title'], 
      thumbnail: json['thumbnail'], 
      video: json['video']);
  }
}