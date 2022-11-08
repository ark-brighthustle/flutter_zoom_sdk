import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/news/news_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import 'detail_smart_news_page.dart';

class SmartNewsPage extends StatefulWidget {
  const SmartNewsPage({Key? key}) : super(key: key);

  @override
  State<SmartNewsPage> createState() => _SmartNewsPageState();
}

class _SmartNewsPageState extends State<SmartNewsPage> {
  List newsList = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  Future _getNewsList() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    var newsService = NewsService();
    var response = await newsService.getDataNews();
    if (response != null) {
      if (!mounted) return;
      setState(() {
        newsList = response;
        isLoading = false;
        cekKoneksi = true;
      });
    } else {
      setState(() {
        isLoading = false;
        cekKoneksi = false;
      });
    }
  }

  Future onRefresh() async {
    await _getNewsList();
  }

  @override
  void initState() {
    _getNewsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            itemNewsList(size),
          ],
        ),
      ),
    );
  }

  Widget buildIconBack() => Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(left: 8, top: padding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: kGrey.withOpacity(0.7)),
        child: Center(
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                size: 20,
              )),
        ),
      );

  Widget buildTitlePage() => const Padding(
        padding: EdgeInsets.only(left: 8, top: padding),
        child: Text(
          titleSmartNews,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  Widget buildHeader() => Container(
        margin: const EdgeInsets.only(top: padding, bottom: padding / 4),
        color: kTransparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildIconBack(), buildTitlePage()],
        ),
      );

  Widget itemNewsList(Size size) => Expanded(
        child: RefreshIndicator(
            onRefresh: onRefresh,
            color: kCelticBlue,
            child: cekKoneksi == true
                ? isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : newsList.isEmpty
                        ? buildNoData()
                        : ListView.builder(
                            itemCount: newsList.length,
                            itemBuilder: (context, i) {
                              String dt = newsList[i].tanggalUpload;
                              String day = DateFormat.EEEE("id_ID")
                                  .format(DateTime.parse(dt));
                              String date = DateFormat.d("id_ID")
                                  .format(DateTime.parse(dt));
                              String monthYears = DateFormat.yMMM("id_ID")
                                  .format(DateTime.parse(dt));
                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailSmartNewsPage(
                                                    linkBerita:
                                                        newsList[i].linkBerita,
                                                  ))),
                                      child: SizedBox(
                                        width: size.width,
                                        height: size.height * 0.2,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              newsList[i].linkFoto,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.broken_image,
                                                          size: 90,
                                                          color: kGrey,
                                                        ),
                                                      ],
                                                    ));
                                              },
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Text(
                                        newsList[i].judul,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$day, $date $monthYears",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: IconButton(
                                            onPressed: () => Share.share("${newsList[i].judul} ${newsList[i].linkBerita}"),
                                            icon: const Icon(
                                              Icons.share,
                                              size: 20,
                                              color: kBlack45,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    )
                                  ],
                                ),
                              );
                            })
                : buildNoKoneksi()),
      );

  Widget buildNoData() => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kCelticBlue)),
            onPressed: onRefresh,
            child: const Text(
              "Refresh",
              style: TextStyle(color: Colors.white),
            ),
          )
        ]),
      );

  Widget buildNoKoneksi() => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kCelticBlue)),
          onPressed: onRefresh,
          child: const Text(
            "Refresh",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]));
}
