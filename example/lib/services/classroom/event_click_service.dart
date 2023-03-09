import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/classroom/event_click_model.dart';
import '../../utils/config.dart';

class EventClickService{
  eventClick(String data, String id) async{
    var url = Uri.parse("$API_V2/materi-live/$data/$id/click");
    String? token = await Helpers().getToken();
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return EventClickModel.fromJson(responseJson);
    } else {
      return throw Exception('Failed to load');
    }
  }
}