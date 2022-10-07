import 'package:shared_preferences/shared_preferences.dart';

class Helpers {
  Future<int?> getIdKelas() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('id_kelas');
  }

  Future<String?> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('access_token');
  }
}