import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/news/news_service.dart';
import '../../theme/colors.dart';
import '../../utils/constant.dart';
import 'detail_smart_news_page.dart';

class SmartNewsPage extends StatefulWidget {
  const SmartNewsPage({Key? key}) : super(key: key);

  @override
  State<SmartNewsPage> createState() => _SmartNewsPageState();
}

class _SmartNewsPageState extends State<SmartNewsPage> {
  List newsList = [];

  Future _getNewsList() async {
    var newsService = NewsService();
    var response = await newsService.getDataNews();
    if (!mounted) return;
    setState(() {
      newsList = response;
    });
  }

  @override
  void initState() {
    _getNewsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleSmartNews),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: itemNewsList(),
      ),
    );
  }

  Widget itemNewsList() {
    return ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, i) {
          String dt = newsList[i].tanggalUpload;
          String day = DateFormat.EEEE("id_ID").format(DateTime.parse(dt));
          String date = DateFormat.d("id_ID").format(DateTime.parse(dt));
          String monthYears = DateFormat.yMMM("id_ID").format(DateTime.parse(dt));
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailSmartNewsPage(
                          linkBerita: newsList[i].linkBerita,
                        ))),
            child: Card(
              child: Container(
                width: double.infinity,
                height: 160,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            newsList[i].linkFoto,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 180,
                      height: 140,
                      child: Stack(
                        children: [
                          Text(
                            newsList[i].judul,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Positioned(
                            bottom: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "$day, $date $monthYears",
                                  style: const TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
