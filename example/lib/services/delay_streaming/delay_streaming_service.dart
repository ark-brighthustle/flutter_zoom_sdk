import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/classroom/event_click_model.dart';
import '../../models/delay_streaming/delay_streaming_model.dart';
import '../../utils/config.dart';

class DelayStreamingService {
  getDataLiveDelay() async {
    var url = Uri.parse(API_DELAY_STREAMING);
    print(url);
    try{
      final response = await http.get(url).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"Live Delay":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => DelayStreamingModel.fromJson(p)).toList();
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

  durationPlay(String idSiswa, String idDelay, String duration) async{
    var url = Uri.parse("$API_LEARNING_RESOUCE_TRACKING/delay-stream/watching/$idSiswa/$idDelay");
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: json.encode(<String, String>{
          'duration': duration,
        }));
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return EventClickModel.fromJson(responseJson);
    }else if(response.statusCode == 404){
      return "Tidak ditemukan";
    }else{
      print("Failed to load");
      return;
    }
  }
}
