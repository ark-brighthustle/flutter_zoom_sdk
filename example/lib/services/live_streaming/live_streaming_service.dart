import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/live_streaming/live_streaming_model.dart';
import '../../utils/config.dart';

class LiveStreamingService {
  getDataLiveStreaming() async {
    int? idKelas = await Helpers().getIdKelas();
    String? token = await Helpers().getToken();
    var url = Uri.parse("$API_V2/live-stream-siswa/$idKelas");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var responseJson = json.decode(response.body);
    var data = responseJson['data'];
    if (response.statusCode == 200) {
      return data.map((p) => LiveStreamingModel.fromJson(p)).toList();
    } else {
      print(data);
      return data;
    }
  }
}