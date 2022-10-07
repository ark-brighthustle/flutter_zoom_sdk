import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../helpers/helpers.dart';
import '../../models/classroom/event_click_model.dart';
import '../../models/classroom/materi_live_model.dart';
import '../../utils/config.dart';

class MateriLiveService {
  getDataMateriLive(String id) async {
    var url = Uri.parse("$API_V2/materi-live/$id");
    String? token = await Helpers().getToken();
    final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => MateriLiveModel.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  DurationPlayVideo(String id, String duration) async {
    var url = Uri.parse("$API_V2/materi-live/video_bahan/$id/duration");
    String? token = await Helpers().getToken();
    final response = await http.post(url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: json.encode(<String, String>{
          'duration': duration,
        })
    );
    var responseJson = jsonDecode(response.body);
    if(response.statusCode == 200) {
      return EventClickModel.fromJson(responseJson);
    }else if(response.statusCode == 404){
      return "Tidak ditemukan";
    }else{
      print("Failed to load");
      return;
    }
  }
}