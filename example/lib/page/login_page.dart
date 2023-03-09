import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/bottom_navbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../theme/colors.dart';
import '../theme/padding.dart';
import '../utils/config.dart';
import '../utils/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nisn = TextEditingController();
  final TextEditingController _password = TextEditingController();

  var isLoading = false;
  late bool _showPassword = true;
  String? _version;
  int? kode;
  String? token;

  @override
  void initState() {
    initPackageInfo();
    getPref();
    super.initState();
  }

  initPackageInfo() async {
    final _packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = _packageInfo.version;
    });
  }

  login() async {
    var url = Uri.parse('$API_V2/siswa/login');
    final response = await http.post(
      url,
      body: {'nisn': _nisn.text, 'password': _password.text},
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      int kode = data['code'];
      String status = data['status'];
      String pesan = data['message'];

      if (kode == 200) {
        Map<String, dynamic> user = data['data'];
        Map<String, dynamic> auth = data['authorization'];

        savePref(
            200,
            user['id_siswa'],
            user['email'],
            user['nisn'],
            user['nama'],
            user['angkatan'],
            user['tingkat'],
            user['nik'],
            user['jenis_kelamin'],
            user['id_identitas_sekolah'],
            user['sekolah'],
            user['id_kelas'],
            user['kelas'],
            user['jurusan'],
            user['foto'],
            true);

        saveAuth(
          200,
          auth['access_token'],
          auth['token_type'],
        );

        displaySnackBar(pesan);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt("idSiswa", user['id_siswa']);
        await preferences.setString("nama", user['nama']);
        await preferences.setString("nisn", user['nisn']);
        await preferences.setString("nik", user['nik']);
        await preferences.setString("jenisKelamin", user['jenis_kelamin']);
        await preferences.setInt("idIdentitasSekolah", user['id_identitas_sekolah']);
        await preferences.setString("sekolah", user['sekolah']);
        await preferences.setInt("id_kelas", user['id_kelas']);
        await preferences.setString("kelas", user['kelas']);
        await preferences.setString("jurusan", user['jurusan']);
        await preferences.setString("foto", user['foto']);
        await preferences.setBool("banner", true);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const BottomNavbar(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pop(context);
        displaySnackBar(pesan);
      }
    } else {
      Navigator.pop(context);
      displaySnackBar("Login gagal");
    }
  }

  savePref(
      int kode,
      int idSiswa,
      String email,
      String nisn,
      String nama,
      int angkatan,
      String tingkat,
      String nik,
      String jekel,
      int idIdentitasSekolah,
      String sekolah,
      int idKelas,
      String kelas,
      String jurusan,
      String foto,
      bool banner
      ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("code", kode);
    await preferences.setInt("id_siswa", idSiswa);
    await preferences.setString("email", email);
    await preferences.setString("nisn", nisn);
    await preferences.setString("nama", nama);
    await preferences.setString("angkatan", angkatan.toString());
    await preferences.setString("tingkat", tingkat);
    await preferences.setString("nik", nik);
    await preferences.setString("jenis_kelamin", jekel);
    await preferences.setInt("id_identitas_sekolah", idIdentitasSekolah);
    await preferences.setString("sekolah", sekolah);
    await preferences.setInt("id_kelas", idKelas);
    await preferences.setString("kelas", kelas);
    await preferences.setString("jurusan", jurusan);
    await preferences.setString("foto", foto);
    await preferences.setBool("banner", banner);
    // ignore: deprecated_member_use
    await preferences.commit();
  }

  saveAuth(int kode, String token, String tokentype) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("code", kode);
    await preferences.setString("access_token", token);
    await preferences.setString("token_type", tokentype);
    // ignore: deprecated_member_use
    await preferences.commit();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kode = preferences.getInt("code");

      kode == 200
          ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const BottomNavbar(),
                ),
                (route) => false,
              );
            })
          : const LoginPage();
    });
  }

  showAlertDialogLoading(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 15), child: const Text("Loading...", style: TextStyle(fontSize: 12),)),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(padding),
            alignment: Alignment.center,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconLogo(),
                    formLogin(),
                    textInfo(),
                    textVersionName()
                  ],
                ),
              ),
            )));
  }

  Widget iconLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/logo_app.png',
          width: 320,
        ),
      ],
    );
  }

  Widget formLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    titlePageLogin,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    textSubtitleLogin,
                    style: TextStyle(color: kBlack, fontSize: 12),
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    "NISN",
                    style: TextStyle(
                        color: kBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kCelticBlue.withOpacity(0.1)),
              child: TextFormField(
                controller: _nisn,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(
                    Icons.account_circle_rounded,
                  ),
                  border: InputBorder.none,
                  hintText: 'NISN',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan NISN';
                  } else if (value.length < 10 || value.length > 10) {
                    return 'NISN Salah';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    "Password",
                    style: TextStyle(
                        color: kBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kCelticBlue.withOpacity(0.1)),
              child: TextFormField(
                controller: _password,
                obscureText: _showPassword,
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16),
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: togglePasswordVisibility,
                    child: _showPassword
                        ? const Icon(
                            Icons.visibility_off,
                            color: kCelticBlue,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: kCelticBlue,
                          ),
                  ),
                  border: InputBorder.none,
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukkan Password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () {
                if (!isLoading) {
                  if (_formKey.currentState!.validate()) {
                    showAlertDialogLoading(context);
                    login();
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kCelticBlue,
                ),
                child: const Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue.withOpacity(0.3)),
      child: Row(
        children: const [
          Icon(
            Icons.info,
            color: kCelticBlue,
            size: 16,
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
              child: Text(
            textInfoLogin,
            style: TextStyle(
                fontSize: 10, color: kCelticBlue, fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }

  Widget textVersionName() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.bottomCenter,
      child: Text(
        "v$_version",
        style: const TextStyle(fontSize: 12, color: kCelticBlue),
      ),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
