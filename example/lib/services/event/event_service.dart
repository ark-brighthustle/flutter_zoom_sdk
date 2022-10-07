import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/event/event_model.dart';
import '../../utils/config.dart';

class EventService {
  getDataEventKompetisi() async {
    var url = Uri.parse(API_EVENT_KOMPETISI);
    final response = await http.get(url);
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
       if (response.body == '"Event:" null') {
        return throw Exception('No result');
      } else {
        var data = responseJson['data'];
        return data.map((p) => EventModel.fromJson(p)).toList();
      }
    } else {
      return throw Exception('Failed to load');
    }
  }
}