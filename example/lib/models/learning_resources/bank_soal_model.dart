class BankSoalModel {
  int? id;
  int? pelajaranId;
  String? kodeSoal;
  String? materiPokok;
  String? fileSoal;
  String? fileVideo;
  String? createdAt;
  String? updatedAt;

  BankSoalModel({
    required this.id,
    required this.pelajaranId,
    required this.kodeSoal,
    required this.materiPokok,
    required this.fileSoal,
    required this.fileVideo,
    required this.createdAt,
    required this.updatedAt
  });

  factory BankSoalModel.fromJson(Map<String, dynamic> json){
    return BankSoalModel(
      id: json['id'], 
      pelajaranId: json['pelajaran_id'], 
      kodeSoal: json['kode_soal'], 
      materiPokok: json['materi_pokok'], 
      fileSoal: json['file_soal'], 
      fileVideo: json['file_video'], 
      createdAt: json['created_at'], 
      updatedAt: json['updated_at']);
  }
}