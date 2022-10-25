import 'dart:convert';

import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/jawaban_soal_ujian_model.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/response_jawaban_soal_ujian_model.dart';
import 'package:http/http.dart' as http;
import '../../helpers/helpers.dart';
import '../../models/classroom/soal_ujian/soal_ujian_model.dart';
import '../../utils/config.dart';

class SoalUjianService {
  getDataSoalUjian(int id) async {
    var url = Uri.parse("$API_V2/elearning/ujian/soal/$id");
    String? token = await Helpers().getToken();
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception('Failed to load');
    }
  }

  getDetailHasilUjian(int id) async {
    var url = Uri.parse("$API_V2/elearning/ujian/detail_hasil/$id");
    String? token = await Helpers().getToken();
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception('Failed to load');
    }
  }

  createJawabanSoalUjian(Map<String,String> data) async {
    String token = await Helpers().getToken() ?? "";
    var baseResponse;
    var url = Uri.parse("$API_V2/elearning/ujian/soal/jawab");
    try {
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "Bearer $token"
          },
          body: data
      );
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseJson == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = ResponseJawabanSoalUjianModel<JawabanSoalUjianModel>.fromJson(responseJson,
                  (data) => JawabanSoalUjianModel.fromJson(data));
          return baseResponse;
        }
      } else {
        baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }

   getDataHasilUjian(int id) async {
    var url = Uri.parse("$API_V2/elearning/ujian/hasil/$id");
    String? token = await Helpers().getToken();
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception('Failed to load');
    }
  }
}