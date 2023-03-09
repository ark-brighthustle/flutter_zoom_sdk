import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/character/amaliah_reference.dart';
import '../../models/character/fiqih_model.dart';
import '../../models/character/hadist_model.dart';
import '../../models/character/hafalan_quran_model.dart';
import '../../models/character/kategori_penguatan_karakter_tematik_model.dart';
import '../../models/character/penguatan_karakter_tematik_model.dart';
import '../../models/classroom/event_click_model.dart';
import '../../utils/config.dart';

class CharacterService{
  getDataHadist(String siswa) async {
    var url = Uri.parse("$API_CHARACTER/recitation/hadist?filters[siswa]="+siswa);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => HadistModel.fromJson(p)).toList();
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

  getDataHafalanSurahQuran(String siswa) async {
    var url = Uri.parse("$API_CHARACTER/recitation/quran?filters[siswa]="+siswa);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => HafalanQuaranModel.fromJson(p)).toList();
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

  getDataFiqih(String siswa) async {
    var url = Uri.parse("$API_CHARACTER/recitation/fiqih?filters[siswa]="+siswa);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => FiqihModel.fromJson(p)).toList();
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

  getDataTulisAlQuran(String siswa) async {
    var url = Uri.parse("$API_CHARACTER/writing/quran?filters[siswa]="+siswa);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson;
          return data;
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

  getDataBacaAlQuran(String siswa) async {
    var url = Uri.parse("$API_CHARACTER/reading/quran?filters[siswa]="+siswa);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson;
          return data;
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

  getKategoriPenguatanKarakterTematik() async {
    var url = Uri.parse("$API_CHARACTER/categories");
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => KategoriPenguatanKarakterTematikModel.fromJson(p)).toList();
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

  getPenguatanKarakterTematik(String idIdentitasSekolah, String idkategori) async {
    var url = Uri.parse("$API_CHARACTER/videos?filters[school]="+idIdentitasSekolah+"&filters[status]=approved&filters[category]="+idkategori);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => PenguatanKarakterTematikModel.fromJson(p)).toList();
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

  getAmaliahReferensi(String idIdentitasSekolah) async{
    var url = Uri.parse("$API_CHARACTER/amaliah/reference/verified/approved?filters[sekolah]="+idIdentitasSekolah);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }).timeout(const Duration(seconds: 7));
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (response.body == '{"data":null}') {
          return throw Exception('No results');
        } else {
          var data = responseJson['data'];
          return data.map((p) => AmaliahReference.fromJson(p)).toList();
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

  DurationPlayPenguatanKarakter(String id_siswa, String id_delay, String duration) async{
    var url = Uri.parse("$API_CHARACTER_DURATION_PLAY/tracking/video/watching/${id_siswa}/${id_delay}");
    print(duration.toString());
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