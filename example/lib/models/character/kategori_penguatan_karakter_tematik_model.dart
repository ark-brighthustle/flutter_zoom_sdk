class KategoriPenguatanKarakterTematikModel{
  int? id;
  String? name;
  String? description;

  KategoriPenguatanKarakterTematikModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory KategoriPenguatanKarakterTematikModel.fromJson(Map<String?, dynamic> json) {
    return KategoriPenguatanKarakterTematikModel(
        id: json['id'],
        name: json['name'],
        description: json['description']);
  }
}