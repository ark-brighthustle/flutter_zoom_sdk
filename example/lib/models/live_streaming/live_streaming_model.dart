class LiveStreamingModel {
  int? kodeJdwl;
  int? idTahunAkademik;
  int? idIdentitasSekolah;
  String? kodeTingkat;
  int? jamKe;
  String? jamMulai;
  String? jamSelesai;
  String? hari;
  int? idMataPelajaran;
  String? kodePelajaran;
  String? namaMataPelajaran;
  int? idKelas;
  String? kelas;
  int? idRuangan;
  String? kodeRuangan;
  String? namaRuangan;
  int? idGuru;
  String? meetingId;
  String? passcode;
  String? joinUrl;

  LiveStreamingModel({
    required this.kodeJdwl,
    required this.idTahunAkademik,
    required this.idIdentitasSekolah,
    required this.kodeTingkat,
    required this.jamKe,
    required this.jamMulai,
    required this.jamSelesai,
    required this.hari,
    required this.idMataPelajaran,
    required this.kodePelajaran,
    required this.namaMataPelajaran,
    required this.idKelas,
    required this.kelas,
    required this.idRuangan,
    required this.kodeRuangan,
    required this.namaRuangan,
    required this.idGuru,
    required this.meetingId,
    required this.passcode,
    required this.joinUrl
  });

  factory LiveStreamingModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamingModel(
      kodeJdwl: json['kodejdwl'], 
      idTahunAkademik: json['id_tahun_akademik'], 
      idIdentitasSekolah: json['id_identitas_sekolah'], 
      kodeTingkat: json['kode_tingkat'], 
      jamKe: json['jam_ke'], 
      jamMulai: json['jam_mulai'], 
      jamSelesai: json['jam_selesai'], 
      hari: json['hari'], 
      idMataPelajaran: json['id_mata_pelajaran'], 
      kodePelajaran: json['kode_pelajaran'], 
      namaMataPelajaran: json['namamatapelajaran'], 
      idKelas: json['id_kelas'], 
      kelas: json['kelas'], 
      idRuangan: json['id_ruangan'],
      kodeRuangan: json['kode_ruangan'],
      namaRuangan: json['nama_ruangan'], 
      idGuru: json['id_guru'], 
      meetingId: json['meeting_id'], 
      passcode: json['passcode'], 
      joinUrl: json['join_url']);
  }
}


/*class LiveStreamingModel {
  String? kodeMataPelajaran;
  String? namaPelajaran;
  String? waktuMulai;
  String? waktuSelesai;
  String? joinUrl;
  String? meetingId;
  String? passcode;
  String? signature;

  LiveStreamingModel(
      {
      required this.kodeMataPelajaran,
      required this.namaPelajaran,
      required this.waktuMulai,
      required this.waktuSelesai,
      required this.joinUrl,
      required this.meetingId,
      required this.passcode,
      required this.signature,});

  factory LiveStreamingModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamingModel( 
      kodeMataPelajaran: json['kode_mata_pelajaran'],
      namaPelajaran: json['nama_pelajaran'],  
      waktuMulai: json['waktu_mulai'], 
      waktuSelesai: json['waktu_selesai'], 
      joinUrl: json['join_url'],  
      meetingId: json['meeting_id'], 
      passcode: json['passcode'],
      signature: json['signature'], 
      );
  }
}*/
