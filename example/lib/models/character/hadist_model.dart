class HadistModel{
  int? id;
  String? nama_hadist;
  int? nomor_hadist;
  String? amalan;
  String? hafalan;
  String? created_at;

  HadistModel({
    required this.id,
    required this.nama_hadist,
    required this.nomor_hadist,
    required this.amalan,
    required this.hafalan,
    required this.created_at,
  });

  factory HadistModel.fromJson(Map<String?, dynamic> json) {
    return HadistModel(
        id: json['id'],
        nama_hadist: json['nama_hadist'],
        nomor_hadist: json['nomor_hadist'],
        amalan: json['amalan'],
        hafalan: json['hafalan'],
        created_at: json['created_at']);
  }
}