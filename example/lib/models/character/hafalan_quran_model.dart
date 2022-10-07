class HafalanQuaranModel{
  int? id;
  int? nomor_surah;
  String? nama_surah;
  int? nomor_ayat_dari;
  int? nomor_ayat_sampai;
  String? keterangan;
  String? makhraj;
  String? tajwid;
  String? pelafalan;
  String? created_at;

  HafalanQuaranModel({
    required this.id,
    required this.nomor_surah,
    required this.nama_surah,
    required this.nomor_ayat_dari,
    required this.nomor_ayat_sampai,
    required this.keterangan,
    required this.makhraj,
    required this.tajwid,
    required this.pelafalan,
    required this.created_at
  });

  factory HafalanQuaranModel.fromJson(Map<String?, dynamic> json) {
    return HafalanQuaranModel(
        id: json['id'],
        nomor_surah: json['nomor_surah'],
        nama_surah: json['nama_surah'],
        nomor_ayat_dari: json['nomor_ayat_dari'],
        nomor_ayat_sampai: json['nomor_ayat_sampai'],
        keterangan: json['keterangan'],
        makhraj: json['makhraj'],
        tajwid: json['tajwid'],
        pelafalan: json['pelafalan'],
        created_at: json['created_at']);
  }
}