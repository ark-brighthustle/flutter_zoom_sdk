import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/medical_record/vaksinasi/vaksin_data.dart';
import '../../models/medical_record/vaksinasi/vaksin_data_list_model.dart';
import '../../models/medical_record/vaksinasi/vaksin_family_list_model.dart';
import '../../models/medical_record/vaksinasi/vaksin_family_update_model.dart';
import '../../models/medical_record/vaksinasi/vaksin_siswa_list_model.dart';
import '../../models/medical_record/vaksinasi/vaksin_siswa_model.dart';
import '../../utils/config.dart';

class VaksinService {
  getDataVaksin(int idSiswa) async{
    var baseResponse;
    try{
      var url = Uri.parse("$API_VAKSIN/student/"+idSiswa.toString());
      final response = await http.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
      if (response.statusCode == 200) {
        if (response.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = VaksinSiswaModel<VaksinData>.fromJson(json.decode(response.body), (data) => VaksinData.fromJson(data));
          return baseResponse;
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }

  updateVaksinSiswa(int idSiswa,
      String kk,
      String tempatLahir,
      String tglLahir,
      String email,
      String alamat,
      String noHp) async{
    var baseResponse;
    var url = Uri.parse("$API_VAKSIN/student/update");
    try{
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, String>{
            'id_siswa': "$idSiswa",
            'kk': kk,
            'tempat_lahir': tempatLahir,
            'tanggal_lahir': tglLahir,
            'email': email,
            'alamat': alamat,
            'no_hp': noHp,
          }));
      if (response.statusCode == 200) {
        if (response.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = VaksinSiswaModel<VaksinSiswaListModel>.fromJson(json.decode(response.body), (data) => VaksinSiswaListModel.fromJson(data));
          return baseResponse;
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }

  updateVaksin(int idSiswa,
      String no_vaksin1,
      String no_vaksin2,
      String no_booster) async {
    var baseResponse;
    var url = Uri.parse("$API_VAKSIN/vaccine/update");
    try{
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, String>{
            'id_siswa': "$idSiswa",
            'no_vaksin1': no_vaksin1,
            'no_vaksin2': no_vaksin2,
            'no_booster': no_booster,
          }));
      if (response.statusCode == 200) {
        if (response.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = VaksinSiswaModel<VaksinDataListModel>.fromJson(json.decode(response.body), (data) => VaksinDataListModel.fromJson(data));
          return baseResponse;
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }

  getDatakeluarga(int siswa,
      String getKeluarga) async {
    int keluarga = 0;
    if(getKeluarga == "Ayah"){
      keluarga = 1;
    }else if(getKeluarga == "Ibu"){
      keluarga = 2;
    }else if(getKeluarga == "Saudara"){
      keluarga = 3;
    }
    var url = Uri.parse("$API_VAKSIN/family/"+siswa.toString()+"/"+keluarga.toString());
    var baseResponse;
    try{
      final response = await http.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
      if (response.statusCode == 200) {
        if (response.body == 'null') {
          return throw Exception('No result');
        } else {
          var baseResponse = VaksinSiswaModel<VaksinFamilyListModel>.fromJson(json.decode(response.body), (data) => VaksinFamilyListModel.fromJson(data));
          return baseResponse;
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }

  updateDatakeluarga(int siswa,
      String getKeluarga,
      String nama,
      int jeniskelamin,
      String nik,
      String tanggallahir,
      String novaksin1,
      String novaksin2,
      String nobooster) async {
    int keluarga = 0;
    if(getKeluarga == "Ayah"){
      keluarga = 1;
    }else if(getKeluarga == "Ibu"){
      keluarga = 2;
    }else if(getKeluarga == "Saudara"){
      keluarga = 3;
    }
    var baseResponse;
    var url = Uri.parse("$API_VAKSIN/family/"+siswa.toString()+"/"+keluarga.toString());
    try{
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(<String, String>{
            'nama': nama,
            'id_jenis_kelamin': "$jeniskelamin",
            'nik': nik,
            'tanggal_lahir': tanggallahir,
            'no_vaksin1': novaksin1,
            'no_vaksin2': novaksin2,
            'no_booster': nobooster,
          }));
      if (response.statusCode == 201) {
        if (response.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = VaksinSiswaModel<VaksinFamilyUpdateModel>.fromJson(json.decode(response.body), (data) => VaksinFamilyUpdateModel.fromJson(data));
          return baseResponse;
        }
      } else {
        return baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }
}