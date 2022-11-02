import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/classroom/category_elearning_model.dart';
import '../../utils/config.dart';

class CategoryElearningService {
  getDataCategoryElearning() async {
    var url = Uri.parse("$API_V2/elearning/category");
    String token = await Helpers().getToken() ?? "";
    try{
      final response = await http.get(url, headers: {'Authorization': "Bearer "+ token}).timeout(const Duration(seconds: 7));
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var data = responseJson['data'];
        return data.map((p) => CategoryElearningModel.fromJson(p)).toList();
      } else {
        return throw Exception('Failed to load');
      }
    } on TimeoutException catch (_){
      return null;
    } on SocketException catch (_){
      return null;
    }
  }
}