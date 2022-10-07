class VaksinData{
  int id_siswa;
  String? nama;
  String? jenis_kelamin;
  String? tempat_lahir;
  String? tanggal_lahir;
  String? nik;
  String? no_kk;
  String? email;
  String? hp;
  String? alamat;
  String? no_vaksin1;
  String? no_vaksin2;
  String? no_booster;

  VaksinData(
      {required this.id_siswa,
        required this.nama,
        required this.jenis_kelamin,
        required this.tempat_lahir,
        required this.tanggal_lahir,
        required this.nik,
        required this.no_kk,
        required this.email,
        required this.hp,
        required this.alamat,
        required this.no_vaksin1,
        required this.no_vaksin2,
        required this.no_booster});

  factory VaksinData.fromJson(Map<String, dynamic> json) {
    return VaksinData(
        id_siswa: json['id_siswa'],
        nama: json['nama'],
        jenis_kelamin: json['jenis_kelamin'],
        tempat_lahir: json['tempat_lahir'],
        tanggal_lahir: json['tanggal_lahir'],
        nik: json['nik'],
        no_kk: json['no_kk'],
        email: json['email'],
        hp: json['hp'],
        alamat: json['alamat'],
        no_vaksin1: json['no_vaksin1'],
        no_vaksin2: json['no_vaksin2'],
        no_booster: json['no_booster']);
  }
}