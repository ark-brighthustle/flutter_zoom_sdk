class FiqihModel{
  int? id;
  String? topik;
  String? keterangan;
  String? amalan;
  String? hafalan;
  String? created_at;

  FiqihModel({
    required this.id,
    required this.topik,
    required this.keterangan,
    required this.amalan,
    required this.hafalan,
    required this.created_at
  });

  factory FiqihModel.fromJson(Map<String?, dynamic> json) {
    return FiqihModel(
        id: json['id'],
        topik: json['topik'],
        keterangan: json['keterangan'],
        amalan: json['amalan'],
        hafalan: json['hafalan'],
        created_at: json['created_at']);
  }
}