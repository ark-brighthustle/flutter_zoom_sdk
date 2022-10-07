class MapelModel {
  int? id;
  String? kode;
  String? namaPelajaran;
  int? status;
  int? tingkatId;
  String? kodeTingkat;
  String? createdAt;
  String? updatedAt;

  MapelModel(
      {required this.id,
      required this.kode,
      required this.namaPelajaran,
      required this.status,
      required this.tingkatId,
      required this.kodeTingkat,
      required this.createdAt,
      required this.updatedAt});

  factory MapelModel.fromJson(Map<String, dynamic> json) {
    return MapelModel(
      id: json['id'], 
      kode: json['kode'], 
      namaPelajaran: json['nama_pelajaran'], 
      status: json['status'], 
      tingkatId: json['tingkat_id'], 
      kodeTingkat: json['kode_tingkat'],
      createdAt: json['created_at'], 
      updatedAt: json['updated_at']);
  }
}
