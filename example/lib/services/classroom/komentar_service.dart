import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/classroom/komentar_model.dart';
import '../../utils/config.dart';

Future<Komentar> createComment(String elearningId, String siswaId, String komentar) async {
  String token = await Helpers().getToken() ?? "";
  final response = await http.post(
    Uri.parse('$API_V2/comment'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer '+ token
    },
    body: jsonEncode({
      'elearning_id': elearningId,
      'siswa_id': siswaId,
      'comment': komentar,
    }),
  );

  if (response.statusCode == 200) {
    return Komentar.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create comment.');
  }
}

class AllKomentarService {
  getDataAllKomentar(String elearningId) async {
    var url = Uri.parse("$API_V2/elearning/comment/list/$elearningId");
    String? token = await Helpers().getToken();
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => AllKomentar.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}