class LearningResourcesModel {
  int? id;
  int? mataPelajaranId;
  int? tingkatId;
  int? categoryId;
  int? topikId;
  String? judul;
  String? deskripsi;
  String? youtubeUrl;
  String? fileUrl;
  String? gdriveUrl;
  String? thumbnailUrl;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? mataPelajaran;
  Map<String, dynamic>? category;
  Map<String, dynamic>? tingkat;
  Map<String, dynamic>? topik;

  LearningResourcesModel(
      {required this.id,
      required this.mataPelajaranId,
      required this.tingkatId,
      required this.categoryId,
      required this.topikId,
      required this.judul,
      required this.deskripsi,
      required this.youtubeUrl,
      required this.fileUrl,
      required this.gdriveUrl,
      required this.thumbnailUrl,
      required this.createdAt,
      required this.updatedAt,
      required this.mataPelajaran,
      required this.category,
      required this.tingkat,
      required this.topik});

  factory LearningResourcesModel.fromJson(Map<String, dynamic> json) {
    return LearningResourcesModel(
        id: json['id'],
        mataPelajaranId: json['mata_pelajaran_id'],
        tingkatId: json['tingkat_id'],
        categoryId: json['category_id'],
        topikId: json['topik_id'],
        judul: json['judul'],
        deskripsi: json['deskripsi'],
        youtubeUrl: json['youtube_url'],
        fileUrl: json['file_url'],
        gdriveUrl: json['gdrive_url'],
        thumbnailUrl: json['thumbnail_url'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        mataPelajaran: json['mata_pelajaran'],
        category: json['category'],
        tingkat: json['tingkat'],
        topik: json['topik']);
  }
}

class MapelModel {
  int? idMataPelajaran;
  int? idIdentitasSekolah;
  String? kodePelajaran;
  String? idKelompokMataPelajaran;
  String? idKelompokMataPelajaranSub;
  String? idJurusan;
  String? idGuru;
  String? namaMataPelajaran;
  String? namaMataPelajaranEn;
  String? idTingkat;
  String? kompetensiUmum;
  String? kompetensiKhusus;
  String? jumlahJam;
  String? sesi;
  String? urutan;
  String? kkm;
  String? karakter;
  String? aktif;

  MapelModel(
      {required this.idMataPelajaran,
      required this.idIdentitasSekolah,
      required this.kodePelajaran,
      required this.idKelompokMataPelajaran,
      required this.idKelompokMataPelajaranSub,
      required this.idJurusan,
      required this.idGuru,
      required this.namaMataPelajaran,
      required this.namaMataPelajaranEn,
      required this.idTingkat,
      required this.kompetensiUmum,
      required this.kompetensiKhusus,
      required this.jumlahJam,
      required this.sesi,
      required this.urutan,
      required this.kkm,
      required this.karakter,
      required this.aktif});

  factory MapelModel.fromJson(Map<String, dynamic> json) {
    return MapelModel(
        idMataPelajaran: json['id_mata_pelajaran'],
        idIdentitasSekolah: json['id_identitas_sekolah'],
        kodePelajaran: json['kode_pelajaran'],
        idKelompokMataPelajaran: json['id_kelompok_mata_pelajaran'],
        idKelompokMataPelajaranSub: json['id_kelompok_mata_pelajaran_sub'],
        idJurusan: json['id_jurusan'],
        idGuru: json['id_guru'],
        namaMataPelajaran: json['nama_mata_pelajaran'],
        namaMataPelajaranEn: json['nama_mata_pelajaran_en'],
        idTingkat: json['id_tingkat'],
        kompetensiUmum: json['kompetensi_umum'],
        kompetensiKhusus: json['kompetensi_khusus'],
        jumlahJam: json['jumlah_jam'],
        sesi: json['sesi'],
        urutan: json['urutan'],
        kkm: json['kkm'],
        karakter: json['karakter'],
        aktif: json['aktif']);
  }
}

class CategoryModel {
  int? id;
  String? namaKategori;
  String? createdAt;
  String? updatedAt;

  CategoryModel(
      {required this.id,
      required this.namaKategori,
      required this.createdAt,
      required this.updatedAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'],
        namaKategori: json['nama_kategori'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}

class TingkatModel {
  int? id;
  int? idIdentitasSekolah;
  String? kodeTingkat;
  int? kodeKurikulum;
  String? keterangan;
  int? idRaport;

  TingkatModel(
      {required this.id,
      required this.idIdentitasSekolah,
      required this.kodeTingkat,
      required this.kodeKurikulum,
      required this.keterangan,
      required this.idRaport});

  factory TingkatModel.fromJson(Map<String, dynamic> json) {
    return TingkatModel(
        id: json['id'],
        idIdentitasSekolah: json['id_identitas_sekolah'],
        kodeTingkat: json['kode_tingkat'],
        kodeKurikulum: json['kode_kurikulum'],
        keterangan: json['keterangan'],
        idRaport: json['id_raport']);
  }
}

class TopikModel {
  int? id;
  String? namaTopik;
  String? createdAt;
  String? updatedAt;

  TopikModel(
      {required this.id,
      required this.namaTopik,
      required this.createdAt,
      required this.updatedAt});

  factory TopikModel.fromJson(Map<String, dynamic> json) {
    return TopikModel(
        id: json['id'],
        namaTopik: json['nama_topik'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
