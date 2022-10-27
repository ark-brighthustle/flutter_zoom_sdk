class DetailHasilUjianModel {
  int? id;
  String? soal;
  String? jawaban_pilihan_ganda;
  String? jawaban_benar;
  String? penjelasan_jawaban;
  int? nilai;

  DetailHasilUjianModel({
    required this.id,
    required this.soal,
    required this.jawaban_pilihan_ganda,
    required this.jawaban_benar,
    required this.penjelasan_jawaban,
    required this.nilai,
  });

  factory DetailHasilUjianModel.fromJson(Map<String, dynamic> json) {
    return DetailHasilUjianModel(
      id: json['id'],
      soal: json['soal'],
      jawaban_pilihan_ganda: json['jawaban_pilihan_ganda'],
      jawaban_benar: json['jawaban_benar'],
      penjelasan_jawaban: json['penjelasan_jawaban'],
      nilai: json['nilai']);
  }
}
