class Profil {
  int? idSiswa;
  String? nama;
  String? nisn;
  String? nipd;
  String? email;
  String? agama;
  String? alamat;
  int? angkatan;
  String? tingkat;
  int? idKelas;
  String? kelas;
  String? jurusan;
  String? foto;

  Profil(
      {this.idSiswa,
      this.nama,
      this.nisn,
      this.nipd,
      this.email,
      this.agama,
      this.alamat,
      this.angkatan,
      this.tingkat,
      this.idKelas,
      this.kelas,
      this.jurusan,
      this.foto});

  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
        idSiswa: json['id_siswa'],
        nama: json['nama'],
        nisn: json['nisn'],
        nipd: json['nipd'],
        email: json['email'],
        agama: json['agama'],
        alamat: json['alamat'],
        angkatan: json['angkatan'],
        tingkat: json['tingkat'],
        idKelas: json['id_kelas'],
        kelas: json['kelas'],
        jurusan: json['jurusan'],
        foto: json['foto']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id_siswa": idSiswa,
      "nama": nama,
      "nisn": nisn,
      "nipd": nipd,
      "email": email,
      "agama": agama,
      "alamat": alamat,
      "angkatan": angkatan,
      "tingkat": tingkat,
      "id_kelas": idKelas,
      "kelas": kelas,
      "jurusan": jurusan,
      "foto": foto
    };
  }
}
