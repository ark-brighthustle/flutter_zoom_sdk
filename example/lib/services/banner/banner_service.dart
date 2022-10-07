import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/banner/banner_gub_model.dart';
import '../../models/banner/banner_kompetisi_model.dart';
import '../../utils/config.dart';

class BannerService {
  getDataBannerGub() async {
    var url = Uri.parse("$API_V2/banner");
    final response = await http.get(url);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '{"Banner":null}') {
        return throw Exception('No results');
      } else {
        var data = responseJson['data'];
        return data.map((p) => BannerGubModel.fromJson(p)).toList();
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  getDataBannerKompetisi() async {
    var url = Uri.parse(API_EVENT_KOMPETISI);
    final response = await http
        .get(url);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '{"Banner":null}') {
        return throw Exception('No results');
      } else {
        var data = responseJson['data'];
        return data.map((p) => BannerKompetisiModel.fromJson(p)).toList();
      }
    } else {
      throw Exception('Failed to load');
    }
  }
}
