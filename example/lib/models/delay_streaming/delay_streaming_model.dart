class DelayStreamingModel {
  int? id;
  String? kodeMataPelajaran;
  String? judul;
  String? deskripsi;
  String? youtubeUrl;
  String? gdriveUrl;
  String? thumbnailUrl;
  String? createdAt;
  String? updatedAt;
  String? liveAt;
  int? pelajaranId;
  int? guruSmartId;
  int? idTingkat;
  String? kodeTingkat;
  int? kodeKurikulum;
  String? keterangan;
  int? idRaport;
  int? idIdentitasSekolah;

  DelayStreamingModel(
      {required this.id,
      required this.kodeMataPelajaran,
      required this.judul,
      required this.deskripsi,
      required this.youtubeUrl,
      required this.gdriveUrl,
      required this.thumbnailUrl,
      required this.createdAt,
      required this.updatedAt,
      required this.liveAt,
      required this.pelajaranId,
      required this.guruSmartId,
      required this.idTingkat,
      required this.kodeTingkat,
      required this.kodeKurikulum,
      required this.keterangan,
      required this.idRaport,
      required this.idIdentitasSekolah
      });

  factory DelayStreamingModel.fromJson(Map<String, dynamic> json){
    return DelayStreamingModel(
      id: json['id'], 
      kodeMataPelajaran: json['kode_mata_pelajaran'], 
      judul: json['judul'], 
      deskripsi: json['deskripsi'], 
      youtubeUrl: json['youtube_url'], 
      gdriveUrl: json['gdrive_url'], 
      thumbnailUrl: json['thumbnail'], 
      createdAt: json['created_at'], 
      updatedAt: json['updated_at'],
      liveAt: json['live_at'],
      pelajaranId: json['pelajaran_id'],
      guruSmartId: json['guru_smart_id'],
      idTingkat: json['id_tingkat'],
      kodeTingkat: json['kode_tingkat'],
      kodeKurikulum: json['kode_kurikulum'],
      keterangan: json['keterangan'],
      idRaport: json['id_raport'],
      idIdentitasSekolah: json['id_identitas_sekolah']
      );
  }
}
