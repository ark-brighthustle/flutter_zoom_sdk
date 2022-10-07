import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/classroom/event_click_model.dart';
import '../../models/learning_resources/learning_resources_model.dart';
import '../../utils/config.dart';

class LearningResourceService {
  getDataLearningResource(String topikId, String categoryId, String mapelId) async {
    var url = Uri.parse("$API_LEARNING_RESOURCE/?filters[topic_id]=$topikId&filters[category_id]=$categoryId&filters[mapel_id]=$mapelId");
    final response = await http
        .get(url);
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '{"Learning Resource": null}') {
        return throw Exception('No results');
      } else {
        var data = responseJson['data'];
        return data.map((p) => LearningResourcesModel.fromJson(p)).toList();
      }
    } else {
      return throw Exception('Failed to load');
    }
  }

  getDataCategory() async {
    var url = Uri.parse(API_LEARNING_RESOURCE);
    final response = await http
        .get(url);
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '{"Learning Resource": null}') {
        return throw Exception('No results');
      } else {
        return (responseJson['data'] as List).map((p) => CategoryModel.fromJson(p));
      }
    } else {
      return throw Exception('Failed to load');
    }
  }

  DurationPlayLearningResouce(String id_siswa, String id, String duration) async{
    var url = Uri.parse("$API_LEARNING_RESOUCE_DURATION_PLAY/tracking/learning-resource/watching/${id_siswa}/${id}");
    print(url);
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
