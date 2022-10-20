import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/library/library_model.dart';

class LibraryService {
  getDatalibraryBook() async {
    var url = Uri.parse("https://www.googleapis.com/books/v1/volumes?q=isbn");
    final response = await http.get(url);
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var items = responseJson['items']; 
      return items.map((p) => VolumeJson.fromJson(p)).toList();
    } else {
      print(responseJson['kind']);
      throw Exception('Failed to load');
    }
  }
}