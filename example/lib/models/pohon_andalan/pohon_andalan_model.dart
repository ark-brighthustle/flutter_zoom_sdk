class PohonAndalanModel {
  int? id;
  String? nama;
  String? deskripsi;
  String? foto;
  String? lat;
  String? lng;
  String? timestamps;

  PohonAndalanModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.foto,
    required this.lat,
    required this.lng,
    required this.timestamps,
  });

  factory PohonAndalanModel.fromJson(Map<String?, dynamic> json) {
    return PohonAndalanModel(
        id: json['id'],
        nama: json['nama'],
        deskripsi: json['deskripsi'],
        foto: json['foto'],
        lat: json['lat'],
        lng: json['lng'],
        timestamps: json['timestamps']);
  }
}
