import 'dart:convert';

import 'package:http/http.dart'  as http;

import '../../models/podcast/podcast_model.dart';
import '../../utils/config.dart';

class PodcastService {
  getDataPodcast() async {
    var url = Uri.parse(API_EVENT_PODCAST);
    final response = await http.get(url);
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
  }  
}