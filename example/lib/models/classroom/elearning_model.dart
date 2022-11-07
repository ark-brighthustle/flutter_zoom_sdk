class ElearningModel {
  int? id;
  int? elearningCategoryId;
  String? namaKategori;
  int? idMataPelajaran;
  String? namaMataPelajaran;
  String? judul;
  String? deskripsi;
  String? fileUrl;
  String? videoUrl;
  String? waktuMulai;
  String? waktuSelesai;
  String? statusWaktu;
  bool? statusKerjakan;
  int? duration;

  ElearningModel(
      {required this.id,
      required this.elearningCategoryId,
      required this.namaKategori,
      required this.idMataPelajaran,
      required this.namaMataPelajaran,
      required this.judul,
      required this.deskripsi,
      required this.fileUrl,
      required this.videoUrl,
      required this.waktuMulai,
      required this.waktuSelesai,
      required this.statusWaktu,
      required this.statusKerjakan,
      required this.duration});

  factory ElearningModel.fromJson(Map<String, dynamic> json) {
    return ElearningModel(
      id: json['id'], 
      elearningCategoryId: json['elearning_category_id'], 
      namaKategori: json['nama_kategori'],
      idMataPelajaran: json['id_mata_pelajaran'],
      namaMataPelajaran: json['nama_mata_pelajaran'], 
      judul: json['judul'], 
      deskripsi: json['deskripsi'], 
      fileUrl: json['file_url'], 
      videoUrl: json['video_url'], 
      waktuMulai: json['waktu_mulai'], 
      waktuSelesai: json['waktu_selesai'],
      statusWaktu: json['status_waktu'],
      statusKerjakan: json['status_kerjakan'],
      duration: json['duration']);
  }
}
