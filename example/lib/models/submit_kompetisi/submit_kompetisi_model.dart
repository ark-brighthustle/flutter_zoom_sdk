class SubmitKompetisiModel {
  final int userId;
  final String competitionId;
  final String description;
  final String image;
  final String status;
  final String updatedAt;
  final String createdAt;
  final int id;

  const SubmitKompetisiModel({required this.userId, required this.competitionId, required this.description, required this.image, required this.status, required this.updatedAt, required this.createdAt, required this.id});

  factory SubmitKompetisiModel.fromJson(Map<String, dynamic> json) {
    return SubmitKompetisiModel(
      userId: json['user_id'],
      competitionId: json['competition_id'],
      description: json['description'],
      image: json['image'],
      status: json['status'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }
}