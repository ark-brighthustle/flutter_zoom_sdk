import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/submit_kompetisi/submit_kompetisi_model.dart';
import '../../utils/config.dart';

Future<SubmitKompetisiModel> submitKompetisi(String idSiswa, String idKompetisi, String deskripsi, String image) async {
    final response = await http.post(
      Uri.parse('$API_V2/submit/kompetisi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': idSiswa,
        'competition_id': idKompetisi,
        'description': deskripsi,
        'image': image,
        'status': '0',
      }),
    );

    if (response.statusCode == 201) {
      return SubmitKompetisiModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to submit');
    }
  }