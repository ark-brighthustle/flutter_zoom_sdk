import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/account/profil_model.dart';
import '../models/update/update_app_model.dart';
import '../services/account/profil_services.dart';
import '../services/banner/banner_service.dart';
import '../services/update_app_service/update_app_service.dart';
import '../theme/colors.dart';
import '../theme/padding.dart';
import 'account/account_page.dart';
import 'banner/detail_banner_page.dart';
import 'learning_resources/learning_resource_page.dart';
import 'medical_record/medical_record-page.dart';
import 'pohon_andalan/pohon_andalan_page.dart';
import 'smart_character/smart_character_page.dart';
import 'smart_diary/smart_diary_page.dart';
import 'smart_event/kompetisi_page.dart';
import 'smart_event/smart_event_page.dart';
import 'smart_library/smart_library_page.dart';
import 'smart_news/smart_news_page.dart';
import 'smart_passion/smart_passion_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  final CarouselController _carouselController = CarouselController();
  int? idSiswa;
  String? nama;
  String? email;
  String? nisn;
  String? kelas;
  String? tingkat;
  String? angkatan;
  String? nik;
  String? jekel;
  int? idIdentitasSekolah;
  String? foto;
  String? token;

  int _currentIndex = 0;

  List bannerGubList = [];
  List bannerKompetisiList = [];
  Future<Profil>? _futureProfil;
  Future<UpdateAppModel>? _futureUpdate;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;

  Future getSiswa() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idSiswa = preferences.getInt('idSiswa');
      nama = preferences.getString("nama");
      email = preferences.getString("email");
      nisn = preferences.getString("nisn");
      kelas = preferences.getString("kelas");
      tingkat = preferences.getString("tingkat");
      angkatan = preferences.getString("angkatan");
      nik = preferences.getString("nik");
      jekel = preferences.getString("jenis_kelamin");
      idIdentitasSekolah = preferences.getInt("idIdentitasSekolah");
      foto = preferences.getString("foto");
      token = preferences.getString("access_token");
    });
  }

  Future getBannerGubList() async {
    var response = await BannerService().getDataBannerGub();
    if (!mounted) return;
    setState(() {
      bannerGubList = response;
    });
  }

  Future getBannerKompetisiList() async {
    var response = await BannerService().getDataBannerKompetisi();
    if (!mounted) return;
    setState(() {
      bannerKompetisiList = response;
    });
  }

  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  void initState() {
    super.initState();
    getSiswa();
    getBannerGubList();
    getBannerKompetisiList();
    _futureProfil = fetchProfil();
    _futureUpdate = fetchUpdateApp();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureProfil = fetchProfil();
    });

    return Scaffold(
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader(),
                  sliderBanner(),
                  gridKategori(),
                  bannerNewsEvent(),
                ],
              ),
            )));
  }

  buildHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.3,
      padding: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24)),
          color: kCelticBlue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/logo.png",
                width: 60,
              ),
              Image.asset(
                "assets/text_logo.png",
                width: 60,
              ),
              const Spacer(),
              FutureBuilder<Profil>(
                future: _futureProfil,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountPage())),
                        child: Padding(
                          padding: const EdgeInsets.only(right: padding),
                          child: CircleAvatar(
                            backgroundColor: kGrey,
                            backgroundImage:
                                NetworkImage("${snapshot.data!.foto}"),
                            radius: 20,
                          ),
                        ));
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.only(right: padding),
                      child: CircleAvatar(
                        backgroundColor: kGrey,
                        backgroundImage: NetworkImage("${snapshot.error}"),
                        radius: 36,
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: padding),
                    child: Text("Halo, $nama",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kWhite)),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: padding),
                    child: Text(
                      "$kelas",
                      style: const TextStyle(fontSize: 10, color: kWhite),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sliderBanner() {
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      margin: const EdgeInsets.only(top: padding),
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
                items: [
                  for (var i = 0; i < bannerGubList.length; i++)
                    Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "https://drive.google.com/uc?export=download&id=${bannerGubList[i].gambarBanner.substring(32, 65)}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Gagal Memuat Gambar!",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            )),
                      ],
                    )
                ],
                carouselController: _carouselController,
                options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 2.4,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    initialPage: 2,
                    pauseAutoPlayOnTouch: true,
                    autoPlayInterval: const Duration(seconds: 7),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    })),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bannerGubList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget titleKategori() {
    return const Padding(
      padding: EdgeInsets.only(left: padding, top: padding, bottom: 8),
      child: Text('Ekosistem Andalan',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: kBlack)),
    );
  }

  Widget gridKategori() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleKategori(),
          Expanded(
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: (const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: padding,
                  mainAxisSpacing: padding)),
              padding: const EdgeInsets.all(padding),
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MedicalRecordPage(
                              isEdit: true,
                              idSiswa: int.parse(idSiswa.toString()),
                              nik: nik.toString(),
                              jekel: jekel.toString(),
                              email: email.toString()))),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/medical_record.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Medical Record",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SmartNewsPage())),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/news.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Smart News",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SmartLibraryPage())),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/library.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Smart Library",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SmartCharacterPage(
                              idSiswa: idSiswa.toString(),
                              idIdentitasSekolah:
                                  idIdentitasSekolah.toString()))),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/karakter.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Smart Character",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SmartEventPage(idSiswa: idSiswa.toString()))),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/event.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Smart Event",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LearningResourcePage())),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/learning_resource.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Learning Resource",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SmartPassionPage())),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/passion.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Smart Passion",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SmartDiaryPage())),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/diary.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Smart Diary",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      await LaunchApp.openApp(
                      androidPackageName: 'com.bekalislam.dzikirndoa',
                      //iosUrlScheme: 'pulsesecure://',
                      //appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                      //openStore: false
                    );
                    },
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icon/zikir_doa.png",
                            width: 36,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            "Dzikir dan Doa",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PohonAndalanPage(idSiswa: idSiswa.toString()))),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/pohon_andalan.png",
                          width: 36,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Pohon\nAndalan",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget titleNewsEvent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 0, 8),
          child: Text('Terbaru Untukmu',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: kBlack)),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      KompetisiPage(idSiswa: idSiswa.toString()))),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
            child: Text('Lihat Semua',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kCelticBlue)),
          ),
        ),
      ],
    );
  }

  Widget bannerNewsEvent() {
    return bannerKompetisiList.isEmpty
        ? Container()
        : SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleNewsEvent(),
                Expanded(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bannerKompetisiList.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailBannerNewsEvent(
                                          idSiswa: idSiswa.toString(),
                                          title: bannerKompetisiList[i].title,
                                          category:
                                              bannerKompetisiList[i].category,
                                          description: bannerKompetisiList[i]
                                              .description,
                                          imageUrl:
                                              bannerKompetisiList[i].imageUrl,
                                          juknisUrl: bannerKompetisiList[i]
                                              .technicalUrl,
                                        )),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              width: double.infinity,
                              height: 168,
                              decoration: const BoxDecoration(
                                  color: kGrey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        bannerKompetisiList[i].imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "Gagal Memuat Gambar!",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: Container(
                                      width: 60,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          color: kYellow,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Center(
                                          child: Text(
                                        "Lihat",
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })),
              ],
            ),
          );
  }
}
