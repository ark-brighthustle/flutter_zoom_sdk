import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  Future _podcast() async {
    var response = await PodcastService().getDataPodcast();
    if (!mounted) return;
    setState(() {
      podcastList = response;
    });
  }

  Future refreshPodcast() async{
    _podcast();
  }

  @override
  void initState() {
    _podcast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
         Row(
            children: [
              IconButton(
                padding: const EdgeInsets.only(left: padding),
                onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 20,)),
              const Padding(
                padding: EdgeInsets.only(left: padding),
                child: Text(titlePodcast, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
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
                }),
          ),
        ],
      ),
    );
  }
}
