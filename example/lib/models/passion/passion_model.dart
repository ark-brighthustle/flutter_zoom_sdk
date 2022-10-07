class CategoriesModel {
  int? id;
  String? name;
  String? createdAt;

  CategoriesModel({required this.id, required this.name, required this.createdAt});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'], 
      name: json['name'], 
      createdAt: json['created_at']);
  }
}

class PassionModel {
  int? id;
  String? title;
  int? categoryId;
  String? summary;
  String? createdAt;
  String? updatedAt;
  int? detailsCount;
  String? categoryName;

  PassionModel(
      {required this.id,
      required this.title,
      required this.categoryId,
      required this.summary,
      required this.createdAt,
      required this.updatedAt,
      required this.detailsCount,
      required this.categoryName});

  factory PassionModel.fromJson(Map<String, dynamic> json) {
    return PassionModel(
        id: json['id'],
        title: json['title'],
        categoryId: json['category_id'],
        summary: json['summary'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        detailsCount: json['details_count'],
        categoryName: json['category_name']);
  }
}
