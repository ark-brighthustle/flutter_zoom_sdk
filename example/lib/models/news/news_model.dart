class NewsModel {
  int? id;
  String? judul;
  String? kategori;
  String? linkFoto;
  String? linkBerita;
  String? deskripsi;
  String? tanggalUpload;

  NewsModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.linkFoto,
    required this.linkBerita,
    required this.deskripsi,
    required this.tanggalUpload
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        judul: json["judul"],
        kategori: json["kategori"],
        linkFoto: json["link_foto"],
        linkBerita: json["link_berita"],
        deskripsi: json['deskripsi'],
        tanggalUpload: json["tanggal_upload"],
      );
}
