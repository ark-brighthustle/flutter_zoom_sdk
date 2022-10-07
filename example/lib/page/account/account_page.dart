import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login.dart';
import '../../models/account/profil_model.dart';
import '../../services/account/profil_services.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import 'data_pribadi_page.dart';
import 'foto_profil_page.dart';
import 'tentang_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
  }) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int? idSiswa;
  String? email;
  String? nisn;
  String? nama;
  String? kelas;
  String? angkatan;
  String? token;

  Future<Profil>? _futureProfil;
  Profil? profil;

  getSiswa() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idSiswa = preferences.getInt("id_siswa");
      email = preferences.getString("email");
      nisn = preferences.getString("nisn");
      nama = preferences.getString("nama");
      kelas = preferences.getString("kelas");
      angkatan = preferences.getString("angkatan");
      token = preferences.getString("access_token");
    });
  }

  @override
  void initState() {
    super.initState();
    getSiswa();
    _futureProfil = fetchProfil();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureProfil = fetchProfil();
    });
    
    return Scaffold(
        backgroundColor: kGrey,
        body: SizedBox(
          child: Stack(
            children: [
              buildHeader(),
              buildBody(),
            ],
          ),
        ));
  }

  Widget buildHeader() {
    return Container(
      color: kCelticBlue,
      height: 200.0,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: kWhite,
                  iconSize: 20,
                ),
                const SizedBox(width: 12,),
                const Text(
                  titleAppBarAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16, color: kWhite),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Profil>(
                      future: _futureProfil,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FotoProfilPage(
                                        foto:
                                            "https://e-andalan.id/images/siswa/default.jpg"))),
                            child: const CircleAvatar(
                              backgroundColor: kGrey,
                              backgroundImage: NetworkImage(
                                  "https://e-andalan.id/images/siswa/default.jpg"),
                              radius: 36,
                            ),
                          );
                        }

                        return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FotoProfilPage(
                                        foto: snapshot.data!.foto.toString()))),
                            child: CircleAvatar(
                              backgroundColor: kGrey,
                              backgroundImage:
                                  NetworkImage("${snapshot.data!.foto}"),
                              radius: 36,
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "$nama",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: kWhite),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 200.0),
      child: Column(
        children: [cardDataPribadi(), cardTentang(), cardLogout()],
      ),
    );
  }

  Widget cardDataPribadi() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DataPribadiPage(
        idSiswa: idSiswa.toString(),
        nama: nama.toString(),
        email: email.toString(),
        nisn: nisn.toString(),
        kelas: kelas.toString(),
        angkatan: angkatan.toString()
      ))),
      child: Container(
          padding: const EdgeInsets.all(padding),
          width: double.infinity,
          color: kWhite,
          margin: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: const [
              Icon(
                Icons.account_circle_rounded,
                color: kCelticBlue,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                textDataPribadi,
                style: TextStyle(fontSize: 14),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
              )
            ],
          )),
    );
  }

  Widget cardTentang() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TentangPage())),
      child: Container(
          padding: const EdgeInsets.all(padding),
          width: double.infinity,
          color: kWhite,
          margin: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: const [
              Icon(
                Icons.info,
                color: kCelticBlue,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                textTentang,
                style: TextStyle(fontSize: 14),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
              )
            ],
          )),
    );
  }

  Widget cardLogout() {
    return GestureDetector(
      onTap: () {
        showAlertExit(context);
      },
      child: Container(
          padding: const EdgeInsets.all(padding),
          width: double.infinity,
          color: kWhite,
          margin: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: const [
              Icon(
                Icons.exit_to_app,
                color: kRed,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                textLogOut,
                style: TextStyle(fontSize: 14),
              ),
            ],
          )),
    );
  }

  showAlertExit(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Anda yakin ingin Keluar ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: signOut,
                  child: const Text('Ya'))
            ],
          );
        });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("code", 0);
      preferences.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    });
  }
}
