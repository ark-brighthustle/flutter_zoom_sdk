import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/update/update_app_model.dart';
import '../../utils/config.dart';

Future<UpdateAppModel> fetchUpdateApp() async {
  final response = await http.get(Uri.parse("$API_V2/version-app"));
  var responseJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    var data = responseJson['data'];
    return UpdateAppModel.fromJson(data);
  } else {
    return throw Exception("Failed to load");
  }
}