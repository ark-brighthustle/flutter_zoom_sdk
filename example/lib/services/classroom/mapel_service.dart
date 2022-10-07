import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/classroom/mapel_model.dart';
import '../../utils/config.dart';

class MapelService {
  getDataMapel() async {
    var url = Uri.parse("$API_V2/mata-pelajaran");
    String? token = await Helpers().getToken();
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => MapelModel.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}