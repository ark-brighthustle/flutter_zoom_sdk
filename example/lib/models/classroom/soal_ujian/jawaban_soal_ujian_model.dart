class JawabanSoalUjianModel <T> {
  int? elearningId;
  int? siswaId;
  int? jumlahJawabanBenar;
  int? jumlahJawabanSalah;
  int? jumlahTidakDijawab;
  double? nilai;
  String? updatedAt;
  String? createdAt;
  int? id;

  JawabanSoalUjianModel({
    required this.elearningId,
    required this.siswaId,
    required this.jumlahJawabanBenar,
    required this.jumlahJawabanSalah,
    required this.jumlahTidakDijawab,
    required this.nilai,
    required this.updatedAt,
    required this.createdAt,
    required this.id
  });

  factory JawabanSoalUjianModel.fromJson(Map<String, dynamic> json) {
    return JawabanSoalUjianModel(
      elearningId: json['elearning_id'], 
      siswaId: json['siswa_id'], 
      jumlahJawabanBenar: json['jumlah_jawaban_benar'], 
      jumlahJawabanSalah: json['jumlah_jawaban_salah'], 
      jumlahTidakDijawab: json['jumlah_tidak_dijawab'], 
      nilai: json['nilai'], 
      updatedAt: json['updated_at'], 
      createdAt: json['created_at'], 
      id: json['id']);
  }
}