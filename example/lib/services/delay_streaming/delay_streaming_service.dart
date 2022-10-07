import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/classroom/event_click_model.dart';
import '../../models/delay_streaming/delay_streaming_model.dart';
import '../../utils/config.dart';

class DelayStreamingService {
  getDataLiveDelay() async {
    var url = Uri.parse(API_DELAY_STREAMING);
    final response = await http.get(url);
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
  }

  DurationPlay(String id_siswa, String id_delay, String duration) async{
    var url = Uri.parse("$API_LEARNING_DURATION_PLAY/tracking/delay-stream/watching/${id_siswa}/${id_delay}");
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
