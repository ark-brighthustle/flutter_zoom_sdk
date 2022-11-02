import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_zoom_sdk_example/helpers/helpers.dart';
import 'package:flutter_zoom_sdk_example/models/event/juara_video_kompetisi_model.dart';
import 'package:http/http.dart' as http;

import '../../models/event/event_model.dart';
import '../../utils/config.dart';

class EventService {
  getDataEventKompetisi() async {
    var url = Uri.parse(API_EVENT_KOMPETISI);
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 7));
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var data = responseJson['data'];
        return data.map((p) => EventModel.fromJson(p)).toList();
      } else {
        return throw Exception('Failed to load');
      }
    } on TimeoutException catch (_){
      return null;
    } on SocketException catch (_){
      return null;
    }
  }

  getDataJuaraKompetisi() async {
    String token = await Helpers().getToken() ?? "";
    var url = Uri.parse("$API_V2/video_competetion_winners");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => JuaraKompetisiModel.fromJson(p)).toList();
    } else {
      return throw Exception('Failed to load');
    }
  }
}