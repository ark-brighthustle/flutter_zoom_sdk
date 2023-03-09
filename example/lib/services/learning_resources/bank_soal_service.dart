import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../models/classroom/event_click_model.dart';
import '../../models/learning_resources/bank_soal_model.dart';
import '../../utils/config.dart';

class BankSoalService {
  getDataBankSoal(String id) async {
    var url = Uri.parse(API_BANK_SOAL+"?filters[mapel_id]="+id);
    try{
      final response = await http.get(url).timeout(const Duration(seconds: 7));
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"Bank Soal": null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => BankSoalModel.fromJson(p)).toList();
        }
      } else {
        return throw Exception('Failed to load');
      }
    } on TimeoutException catch (_){
      return null;
    } on SocketException catch (_){
      return null;
    }
  }


  eventClick(String id_siswa, String id) async{
    var url = Uri.parse("$API_LEARNING_RESOUCE_TRACKING/bank-question/reading/${id_siswa}/${id}");
    final response = await http.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
    );
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return EventClickModel.fromJson(responseJson);
    } else {
      return throw Exception('Failed to load');
    }
  }

  DurationPlayVideoBankSoal(String id_siswa, String id, String duration) async{
    var url = Uri.parse("$API_LEARNING_RESOUCE_TRACKING/bank-question/watching/${id_siswa}/${id}");
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