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
      var data = responseJson['data'];
      return data.map((p) => SoalUjianModel.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  createJawabanSoalUjian(
      String elearningId,
      String nomorSoal,
      String jawaban,
      ) async {
    String token = await Helpers().getToken() ?? "";
    var baseResponse;
    var url = Uri.parse("$API_V2/elearning/ujian/soal/jawab");
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.fields['elearning_id'] = elearningId;
      //request.fields['jawaban[$nomorSoal]'] = jawaban;

      List<String> soal = ["1", "2", "3"];
      List<String> jawaban = ["a", "d", "c"];
      
      for (String item in soal) {
        for (String item2 in jawaban) {
          request.files.add(http.MultipartFile.fromString('jawaban[$item]', item2));
        } 
      }

      var response = await request.send();
      final responseStream = await http.Response.fromStream(response);
      var responseJson = jsonDecode(responseStream.body);
      var message = responseJson['message'];
      if (response.statusCode == 200) {
        print(message);
          baseResponse = ResponseJawabanSoalUjianModel<JawabanSoalUjianModel>.fromJson(
              json.decode(responseStream.body),
              (data) => JawabanSoalUjianModel.fromJson(data));
        return baseResponse;
      } else {
        print(message);
        baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }
}