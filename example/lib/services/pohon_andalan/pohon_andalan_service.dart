import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/pohon_andalan/pohon_andalan_model.dart';
import '../../utils/config.dart';

class PohonAndalanService{
  getPohonAndalan(String npsn, String idSiswa) async {
    var url = Uri.parse("$API_POHON_ANDALAN/40311949/260246");
    final response = await http.get(url);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '{"data":null}') {
        return throw Exception('No results');
      } else {
        var data = responseJson['data'];
        return data.map((p) => PohonAndalanModel.fromJson(p)).toList();
      }
    } else {
      throw Exception('Failed to load');
    }
  }
}