import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/podcast/podcast_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import '../../widget/youtube_video_widget.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({Key? key}) : super(key: key);

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  List podcastList = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  Future _podcast() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    var response = await PodcastService().getDataPodcast();
    if(response != null){
      if (!mounted) return;
      setState(() {
        podcastList = response;
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

  Future refreshPodcast() async{
    await _podcast();
  }

  @override
  void initState() {
    _podcast();
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
        child: itemPodcastList(),
      )),
    );
  }

  Widget itemPodcastList() {
    return RefreshIndicator(
      onRefresh: refreshPodcast,
      color: kCelticBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
          padding: const EdgeInsets.fromLTRB(8, 12, 0, 12),
           child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(left: padding, right: padding),
                  onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 20,)),
                const Text(titlePodcast, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              ],
            ),
         ),
          Expanded(
            child: cekKoneksi == true
              ? isLoading == true
                ? Center(child: CircularProgressIndicator(),)
                : podcastList.length == 0
                  ? buildNoData()
                  : ListView.builder(
                itemCount: podcastList.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      width: double.infinity,
                      height: 140,
                      decoration: const BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Stack(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 120,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: padding),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kWhite),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => YoutubeVideoWidget(
                                                youtubeId: podcastList[i]
                                                    .youtubeUrl
                                                    .substring(32, 43)))),
                                    child: Container(
                                      width: 140,
                                      height: 70,
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            child: CachedNetworkImage(
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                              "https://img.youtube.com/vi/${podcastList[i].youtubeUrl.substring(32, 43)}/0.jpg",
                                              errorWidget:
                                                  (context, url, error) =>
                                              const Icon(Icons.error),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.play_circle_fill_rounded,
                                                size: 30,
                                                color: kWhite.withOpacity(0.7),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    height: 60,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "${podcastList[i].title}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                })
               : buildNoKoneksi()
          ),
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
              onPressed: refreshPodcast,
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
                onPressed: refreshPodcast,
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }
}
