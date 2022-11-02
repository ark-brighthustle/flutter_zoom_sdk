import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'  as http;

import '../../models/podcast/podcast_model.dart';
import '../../utils/config.dart';

class PodcastService {
  getDataPodcast() async {
    var url = Uri.parse(API_EVENT_PODCAST);
    try{
      final response = await http.get(url).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"News":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => PodcastModel.fromJson(p)).toList();
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