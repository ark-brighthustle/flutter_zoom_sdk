import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/passion/passion_model.dart';
import '../../utils/config.dart';

class PassionService {
  getCategoryPassion() async {
    var url = Uri.parse("$API_PASSION/categories");
    final response = await http.get(url);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '"Banner:" null') {
        return throw Exception('No result');
      } else {
        var data = responseJson['data'];
        return data.map((p) => CategoriesModel.fromJson(p)).toList();
      }
    } else {
      return throw Exception('Failed to load');
    }
  }

  getPassion() async {
    var url = Uri.parse("$API_PASSION/passions");
    final response = await http.get(url);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '"Banner:" null') {
        return throw Exception('No result');
      } else {
        var data = responseJson['data'];
        return data.map((p) => PassionModel.fromJson(p)).toList();
      }
    } else {
      return throw Exception('Failed to load');
    }
  }
}
