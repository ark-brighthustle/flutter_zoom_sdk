import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/character/amaliah_personal/amaliah_personal_model.dart';
import '../../models/character/amaliah_personal/amaliah_personal_success_model.dart';
import '../../models/classroom/event_click_model.dart';
import '../../utils/config.dart';


class CharacterAmaliahPersonal{
  tambahPersonalAmaliah(String idIdentitasSekolah, String idSiswa, String topic, File file,String description) async{
    var baseResponse;
    var url = Uri.parse("$API_CHARACTER/amaliah/personal");
    try{
      var request = http.MultipartRequest('POST', url);
      request.fields['id_identitas_sekolah'] = idIdentitasSekolah;
      request.fields['id_siswa'] = idSiswa;
      request.fields['topic'] = topic;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['description'] = description;
      var res = await request.send();
      final respStr = await http.Response.fromStream(res);
      if (res.statusCode == 200) {
        if (respStr.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = AmaliahPersonalModel<AmaliahPersonalSuccessModel>.fromJson(json.decode(respStr.body), (data) => AmaliahPersonalSuccessModel.fromJson(data));
          return baseResponse;
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }

  getPesonalAmaliah(String idSekolah, String idSiswa) async{
    var url = Uri.parse("$API_CHARACTER/amaliah/personal?filters['sekolah']="+idSekolah+"&filters[siswa]="+idSiswa);
    final response = await http.get(url);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (response.body == '{"data":null}') {
        return throw Exception('No results');
      } else {
        var data = responseJson['data'];
        return data.map((p) => AmaliahPersonalSuccessModel.fromJson(p)).toList();
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  hapusPersonalAmaliah(String id, String idSekolah)async{
    var baseResponse;
    var url = Uri.parse("$API_CHARACTER/amaliah/personal/"+id);
    try{
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, String>{
            'id_siswa': id,
            '_method': "delete",
            'id_identitas_sekolah': idSekolah,
          }));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = responseJson;
          return baseResponse;
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }

  DurationPlayReferensi(String id_siswa, String id_delay, String duration) async{
    var url = Uri.parse("$API_CHARACTER_DURATION_PLAY/tracking/reference/watching/${id_siswa}/${id_delay}");
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