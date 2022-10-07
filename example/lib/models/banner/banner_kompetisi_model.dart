class BannerKompetisiModel {
  int? id;
  String? category;
  String? title;
  String? description;
  String? imageUrl;
  String? technicalUrl;
  String? startDate;
  String? endDate;
  int? status;
  String? createdAt;
  String? updatedAt;
 
  BannerKompetisiModel(
      {required this.id,
      required this.category,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.technicalUrl,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  factory BannerKompetisiModel.fromJson(Map<String, dynamic> json) {
    return BannerKompetisiModel(
        id: json['id'],
        category: json['category'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['image_url'],
        technicalUrl: json['technical_url'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
