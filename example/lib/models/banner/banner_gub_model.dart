class BannerGubModel {
  final int id;
  final String namaBanner;
  final String gambarBanner;
  final String createdAt;
  final String updatedAt;

  BannerGubModel(
      {required this.id,
      required this.namaBanner,
      required this.gambarBanner,
      required this.createdAt,
      required this.updatedAt});

  factory BannerGubModel.fromJson(Map<String, dynamic> json) {
    return BannerGubModel(
        id: json['id'],
        namaBanner: json['nama_banner'],
        gambarBanner: json['gambar_banner'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
