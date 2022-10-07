import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/jadwal_siswa/jadwal_siswa_model.dart';
import '../../utils/config.dart';

class JadwalSiswaService {
  getDataJadwalSiswa() async {
    int? idKelas = await Helpers().getIdKelas();
    String? token = await Helpers().getToken();  
    var url = Uri.parse("$API_V2/jadwal_siswa/$idKelas");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token'});
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '{"Jadwal Siswa":null}') {
        return throw Exception('No results');
      } else {
        var data = responseJson['data'];
        return data.map((p) => JadwalSiswaModel.fromJson(p)).toList();
      }
    } else {
      throw Exception('Failed to load');
    }
  }
}