class VaksinSiswaListModel{
  int? id_siswa;
  String? nama;
  String? nik;
  String? no_kk;
  String? jenis_kelamin;
  String? tempat_lahir;
  String? tanggal_lahir;
  String? email;
  String? no_hp;
  String? alamat;

  VaksinSiswaListModel(
      {required this.id_siswa,
        required this.nama,
        required this.nik,
        required this.no_kk,
        required this.jenis_kelamin,
        required this.tempat_lahir,
        required this.tanggal_lahir,
        required this.email,
        required this.no_hp,
        required this.alamat});

  factory VaksinSiswaListModel.fromJson(Map<String, dynamic> json) {
    return VaksinSiswaListModel(
        id_siswa: json['id_siswa'],
        nama: json['nama'],
        nik: json['nik'],
        no_kk: json['no_kk'],
        jenis_kelamin: json['jenis_kelamin'],
        tempat_lahir: json['tempat_lahir'],
        tanggal_lahir: json['tanggal_lahir'],
        email: json['email'],
        no_hp: json['no_hp'],
        alamat: json['alamat']);
  }
}