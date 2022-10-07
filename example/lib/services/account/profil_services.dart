import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/account/profil_model.dart';
import '../../utils/config.dart';

class ProfilServices {
  updateDataProfil(String idSiswa, File foto) async {
    var baseResponse;
    String token = await Helpers().getToken() ?? "";
    var url = Uri.parse("$API_V2/siswa/profile/update/$idSiswa");
    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      request.headers.addAll({'Authorization': 'Bearer $token'});
      var response = await request.send();
      final responseStream = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        if (responseStream.body == 'null') {
          throw Exception('No result');
        } else {
          var resBody = jsonDecode(responseStream.body);
          var message = resBody['message'];
          print(message);
          baseResponse = Profil.fromJson(json.decode(responseStream.body));
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }
}

Future<Profil> fetchProfil() async {
  String token = await Helpers().getToken() ?? "";
  final response = await http.get(Uri.parse('$API_V2/siswa/profile'),
      headers: {'Authorization': 'Bearer $token'});
  if (response.statusCode == 200) {
    var responseJson = jsonDecode(response.body);
    var data = responseJson['data'];
    return Profil.fromJson(data);
  } else {
    throw Exception('Failed to load profil');
  }
}
