import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../../models/news/news_model.dart';
import '../../utils/config.dart';

class NewsService {
  getDataNews() async {
    var url = Uri.parse(API_NEWS);
    try{
      final response = await http.get(url).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"News":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => NewsModel.fromJson(p)).toList();
        }
      } else {
        throw Exception('Failed to load');
      }
    } on TimeoutException catch (_){
      return null;
    } on SocketException catch (_){
      return null;
    }
  }
}