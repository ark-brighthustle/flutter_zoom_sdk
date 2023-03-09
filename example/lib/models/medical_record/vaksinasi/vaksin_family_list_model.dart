class VaksinFamilyListModel {
  String? nama;
  String? nik;
  String? no_kk;
  String? hubungan_keluarga;
  String? tanggal_lahir;
  String? jenis_kelamin;
  String? dose1_num;
  String? dose2_num;
  String? bstr_num;

  VaksinFamilyListModel({
        required this.nama,
        required this.nik,
        required this.no_kk,
        required this.hubungan_keluarga,
        required this.tanggal_lahir,
        required this.jenis_kelamin,
        required this.dose1_num,
        required this.dose2_num,
        required this.bstr_num});

  factory VaksinFamilyListModel.fromJson(Map<String, dynamic> json) {
    return VaksinFamilyListModel(
        nama: json['nama'],
        nik: json['nik'],
        no_kk: json['no_kk'],
        hubungan_keluarga: json['hubungan_keluarga'],
        tanggal_lahir: json['tanggal_lahir'],
        jenis_kelamin: json['jenis_kelamin'],
        dose1_num: json['dose1_num'],
        dose2_num: json['dose2_num'],
        bstr_num: json['bstr_num']);
  }
}
