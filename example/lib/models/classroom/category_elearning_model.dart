class CategoryElearningModel {
  int? id;
  String? namaKategori;
  String? image;
  String? createdAt;
  String? updatedAt;

  CategoryElearningModel(
      {required this.id,
      required this.namaKategori,
      required this.image,
      required this.createdAt,
      required this.updatedAt});

  factory CategoryElearningModel.fromJson(Map<String, dynamic> json){
    return CategoryElearningModel(
      id: json['id'],  
      namaKategori: json['nama_kategori'], 
      image: json['image'], 
      createdAt: json['created_at'], 
      updatedAt: json['updated_at']);
  }
}
