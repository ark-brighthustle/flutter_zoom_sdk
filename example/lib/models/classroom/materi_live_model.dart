class MateriLiveModel {
  int? id;
  int? sesiKe;
  String? judul;
  String? deskripsi;
  int? guruSmartid;
  String? namaGuruSmart;
  int? pelajaranId;
  String? namaMataPelajaran;
  int? tingkatId;
  String? kodeTingkat;
  String? namaTingkat;
  int? tahunAkademikId;
  String? tahunAkademik;
  String? namaTahunAkademik;
  String? urlFileModul;
  String? urlVideoBahan;
  String? bahanAjar;
  String? bahanTayang;
  String? tanggalTayang;
  String? createdAt;
  String? updatedAt;

  MateriLiveModel({
    required this.id,
    required this.sesiKe,
    required this.judul,
    required this.deskripsi,
    required this.guruSmartid,
    required this.namaGuruSmart,
    required this.pelajaranId,
    required this.namaMataPelajaran,
    required this.tingkatId,
    required this.kodeTingkat,
    required this.namaTingkat,
    required this.tahunAkademikId,
    required this.tahunAkademik,
    required this.namaTahunAkademik,
    required this.urlFileModul,
    required this.urlVideoBahan,
    required this.bahanAjar,
    required this.bahanTayang,
    required this.tanggalTayang,
    required this.createdAt,
    required this.updatedAt
  });

  factory MateriLiveModel.fromJson(Map<String, dynamic> json) {
    return MateriLiveModel(
      id: json['id'], 
      sesiKe: json['sesi_ke'], 
      judul: json['judul'], 
      deskripsi: json['deskripsi'], 
      guruSmartid: json['guru_smart_id'], 
      namaGuruSmart: json['nama_guru_smart'], 
      pelajaranId: json['pelajaran_id'], 
      namaMataPelajaran: json['nama_mata_pelajaran'], 
      tingkatId: json['tingkat_id'], 
      kodeTingkat: json['kode_tingkat'], 
      namaTingkat: json['nama_tingkat'], 
      tahunAkademikId: json['tahun_akademik_id'], 
      tahunAkademik: json['tahun_akademik'], 
      namaTahunAkademik: json['nama_tahun_akademik'],
      urlFileModul: json['url_file_modul'],
      urlVideoBahan: json['url_video_bahan'],
      bahanAjar: json['bahan_ajar'],
      bahanTayang: json['bahan_tayang'],
      tanggalTayang: json['tanggal_tayang'], 
      createdAt: json['created_at'], 
      updatedAt: json['updatedAt']);
  }
}