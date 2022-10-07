class JadwalSiswaModel {
  int? kodejdwl;
  int? idKelas;
  String? namaKelas;
  int? idGuru;
  String? namaGuru;
  int? idMataPelajaran;
  String? namaMataPelajaran;
  String? namaRuangan;
  String? hari;
  int? jamKe;
  String? jamMulai;
  String? jamSelesai;

  JadwalSiswaModel({
    required this.kodejdwl,
    required this.idKelas,
    required this.namaKelas,
    required this.idGuru,
    required this.namaGuru,
    required this.idMataPelajaran,
    required this.namaMataPelajaran,
    required this.namaRuangan,
    required this.hari,
    required this.jamKe,
    required this.jamMulai,
    required this.jamSelesai
  });

  factory JadwalSiswaModel.fromJson(Map<String, dynamic> json){
    return JadwalSiswaModel(
      kodejdwl: json['kodejdwl'], 
      idKelas: json['id_kelas'], 
      namaKelas: json['nama_kelas'], 
      idGuru: json['id_guru'], 
      namaGuru: json['nama_guru'], 
      idMataPelajaran: json['id_mata_pelajaran'], 
      namaMataPelajaran: json['nama_mata_pelajaran'], 
      namaRuangan: json['nama_ruangan'], 
      hari: json['hari'], 
      jamKe: json['jam_ke'], 
      jamMulai: json['jam_mulai'], 
      jamSelesai: json['jam_selesai']);
  }

}