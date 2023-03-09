class SoalUjianModel {
  int? id;
  int? elearningId;
  String? judul;
  String? soal;
  String? image;
  String? audio;
  String? video;
  String? pilihanA;
  String? pilihanB;
  String? pilihanC;
  String? pilihanD;
  String? jawaban;

  SoalUjianModel({
    required this.id,
    required this.elearningId,
    required this.judul,
    required this.soal,
    required this.image,
    required this.audio,
    required this.video,
    required this.pilihanA,
    required this.pilihanB,
    required this.pilihanC,
    required this.pilihanD,
    required this.jawaban,
  });

  factory SoalUjianModel.fromJson(Map<String, dynamic> json) {
    return SoalUjianModel(
      id: json['id'], 
      elearningId: json['elearning_id'], 
      judul: json['judul'], 
      soal: json['soal'], 
      image: json['image'], 
      audio: json['audio'], 
      video: json['video'], 
      pilihanA: json['pilihan_a'], 
      pilihanB: json['pilihan_b'], 
      pilihanC: json['pilihan_c'], 
      pilihanD: json['pilihan_d'], 
      jawaban: json['jawaban']);
  }
}
