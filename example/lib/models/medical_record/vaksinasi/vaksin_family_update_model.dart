class VaksinFamilyUpdateModel {
  String? nama;
  String? nik;
  String? no_kk;
  int? id_hubungan_keluarga;
  String? tanggal_lahir;
  int? id_jenis_kelamin;
  String? dose1_num;
  String? dose2_num;
  String? bstr_num;

  VaksinFamilyUpdateModel({
    required this.nama,
    required this.nik,
    required this.no_kk,
    required this.id_hubungan_keluarga,
    required this.tanggal_lahir,
    required this.id_jenis_kelamin,
    required this.dose1_num,
    required this.dose2_num,
    required this.bstr_num});

  factory VaksinFamilyUpdateModel.fromJson(Map<String, dynamic> json) {
    return VaksinFamilyUpdateModel(
        nama: json['nama'],
        nik: json['nik'],
        no_kk: json['no_kk'],
        id_hubungan_keluarga: json['id_hubungan_keluarga'],
        tanggal_lahir: json['tanggal_lahir'],
        id_jenis_kelamin: json['id_jenis_kelamin'],
        dose1_num: json['dose1_num'],
        dose2_num: json['dose2_num'],
        bstr_num: json['bstr_num']);
  }
}
