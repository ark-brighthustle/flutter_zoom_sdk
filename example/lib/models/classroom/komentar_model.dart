class Komentar {
  String? elearningId;
  String? siswaId;
  String? comment;
  String? updatedAt;
  String? createdAt;
  int? id;

  Komentar(
      {required this.elearningId,
      required this.siswaId,
      required this.comment,
      required this.updatedAt,
      required this.createdAt,
      required this.id});

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      elearningId: json['elearning_id'], 
      siswaId: json['siswa_id'], 
      comment: json['comment'], 
      updatedAt: json['updated_at'], 
      createdAt: json['created_at'], 
      id: json['id']);
  }
}

class AllKomentar {
  int? id;
  int? elearningId;
  int? guruId;
  String? namaGuru;
  int? siswaId;
  String? namaSiswa;
  String? comment;
  String? createdAt;

  AllKomentar(
      {required this.id,
      required this.elearningId,
      required this.guruId,
      required this.namaGuru,
      required this.siswaId,
      required this.namaSiswa,
      required this.comment,
      required this.createdAt});

  factory AllKomentar.fromJson(Map<String, dynamic> json) {
    return AllKomentar(
      id: json['id'], 
      elearningId: json['elearning_id'], 
      guruId: json['guru_id'],
      namaGuru: json['nama_guru'], 
      siswaId: json['siswa_id'],
      namaSiswa: json['nama_siswa'], 
      comment: json['comment'], 
      createdAt: json['created_at']);
  }
}


