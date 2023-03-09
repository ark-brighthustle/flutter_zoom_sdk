import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/library/library_model.dart';

class LibraryService {
  getDatalibraryBook() async {
    var url = Uri.parse("https://www.googleapis.com/books/v1/volumes?q=SMA");
    try{
      final response = await http.get(url).timeout(const Duration(seconds: 7));
      var responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var items = responseJson['items'];
        return items.map((p) => VolumeJson.fromJson(p)).toList();
      } else {
        print(responseJson['kind']);
        throw Exception('Failed to load');
      }
    } on TimeoutException catch (_){
      return null;
    } on SocketException catch (_){
      return null;
    }
  }
}