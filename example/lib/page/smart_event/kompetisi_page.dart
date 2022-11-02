import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/event/event_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import '../banner/detail_banner_page.dart';

class KompetisiPage extends StatefulWidget {
  final String idSiswa;
  const KompetisiPage({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<KompetisiPage> createState() => _KompetisiPageState();
}

class _KompetisiPageState extends State<KompetisiPage> {
  List kompetisiList = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  Future _kompetisi() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    var response = await EventService().getDataEventKompetisi();
    if(response != null){
      if (!mounted) return;
      setState(() {
        kompetisiList = response;
        isLoading = false;
        cekKoneksi = true;
      });
    }else{
      setState(() {
        isLoading = false;
        cekKoneksi = false;
      });
    }
  }

  Future refreshKompetisi() async {
    await _kompetisi();
  }

  @override
  void initState() {
    _kompetisi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: itemEventKompetisiList(),
      )),
    );
  }

  Widget headerPage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 0, 12),
      child: Row(
        children: [
          IconButton(
              padding: const EdgeInsets.only(left: padding, right: padding),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                size: 20,
              )),
          const Text(
            titleEventKompetisi,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget itemEventKompetisiList() {
    return RefreshIndicator(
      onRefresh: refreshKompetisi,
      color: kCelticBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerPage(),
          Expanded(
            child: cekKoneksi == true
              ? isLoading == true
                ? Center(child: CircularProgressIndicator(),)
                : kompetisiList.length == 0
                  ? buildNoData()
                  : ListView.builder(
                itemCount: kompetisiList.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailBannerNewsEvent(
                              idSiswa: widget.idSiswa,
                              title: kompetisiList[i].title,
                              category: kompetisiList[i].category,
                              description: kompetisiList[i].description,
                              imageUrl: kompetisiList[i].imageUrl,
                              juknisUrl: kompetisiList[i].technicalUrl,
                            )),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      width: double.infinity,
                      height: 140,
                      decoration: const BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "${kompetisiList[i].imageUrl}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image, color: kGrey,)
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${kompetisiList[i].title}",
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
              : buildNoKoneksi()
          )
        ],
      ),
    );
  }

  Widget buildNoData() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/no_data.svg',
              width: 90,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Belum Ada data",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kCelticBlue)),
              onPressed: refreshKompetisi,
              child: Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
    );
  }

  Widget buildNoKoneksi() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/no_connection.svg',
                width: 120,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Gagal terhubung keserver",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kCelticBlue)),
                onPressed: refreshKompetisi,
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }
}
