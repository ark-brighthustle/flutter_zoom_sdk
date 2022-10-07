import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/classroom/elearning_model.dart';
import '../../utils/config.dart';

class ElearningService {
  getDataElearningBahan() async {
    var url = Uri.parse("$API_V2/elearning/bahan");
    String? token = await Helpers().getToken(); 
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => ElearningModel.fromJson(p)).toList();
    } else {
      return throw Exception('Failed to load');
    }
  }

  getDataElearningTugas() async {
    var url = Uri.parse("$API_V2/elearning/tugas");
    String? token = await Helpers().getToken(); 
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => ElearningModel.fromJson(p)).toList();
    } else {
      return throw Exception('Failed to load');
    }
  }

  getDataElearningUjian(int kodeJadwal) async {
    var url = Uri.parse("$API_V2/elearning/ujian/$kodeJadwal");
    String? token = await Helpers().getToken(); 
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => ElearningModel.fromJson(p)).toList();
    } else {
      return throw Exception('Failed to load');
    }
  }
}