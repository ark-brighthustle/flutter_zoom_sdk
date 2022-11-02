import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/classroom/event_click_model.dart';
import '../../../services/learning_resources/learning_resource_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/padding.dart';
import '../../../widget/play_youtube_video_widget.dart';

// ignore: must_be_immutable
class DetailMenontonPage extends StatefulWidget {
  int? topikId;
  int? categoryId;
  String? title;
  int? mapelId;
  String? namaMapel;
  DetailMenontonPage(
      {Key? key,
      required this.topikId,
      required this.categoryId,
      required this.title,
      required this.mapelId,
      required this.namaMapel})
      : super(key: key);

  @override
  State<DetailMenontonPage> createState() => _DetailMenontonPageState();
}

class _DetailMenontonPageState extends State<DetailMenontonPage> {
  List listLearningResource = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  getLearningResource() async {
    setState((){
      cekKoneksi = true;
      isLoading = true;
    });
    final response = await LearningResourceService().getDataLearningResource(
        widget.topikId.toString(),
        widget.categoryId.toString(),
        widget.mapelId.toString());
    if(response != null){
      if (!mounted) return;
      setState(() {
        listLearningResource = response;
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

  Future onRefresh() async{
    await getLearningResource();
  }

  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  void initState() {
    getLearningResource();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            buildListItem()
          ],
        ),
      )),
    );
  }

  Widget iconButtonBack() {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          size: 20,
        ));
  }

  Widget buildHeader() {
    return Row(
      children: [
        iconButtonBack(),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  "${widget.title}",
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: padding),
                    child: Image.asset(
                      "assets/icon/menonton.png",
                      width: 36,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Text(
                        "${widget.namaMapel}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListItem() {
    return Expanded(
      child: RefreshIndicator(
          onRefresh: onRefresh,
          color: kCelticBlue,
          child: cekKoneksi == true
              ? isLoading == true
                ? Center(child: CircularProgressIndicator())
                : listLearningResource.length == 0
                  ? buildNoData()
                  : ListView.builder(
              itemCount: listLearningResource.length,
              itemBuilder: (context, i) {
                return Container(
                    width: double.infinity,
                    height: 90,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: padding),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: kWhite),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            _CekDurasiPlayYoutube(
                                listLearningResource[i].id.toString(),
                                listLearningResource[i]
                                    .youtubeUrl
                                    .substring(32, 43))
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Stack(
                              children: [
                                listLearningResource[i].youtubeUrl == null
                                    ? const Center(child: Icon(Icons.error))
                                    : ClipRRect(
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    "https://img.youtube.com/vi/${listLearningResource[i].youtubeUrl.substring(32, 43)}/0.jpg",
                                    errorWidget: (context, url, error) =>
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
                          width: 180,
                          height: 60,
                          child: Center(
                            child: Text(
                              "${listLearningResource[i].judul}",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ));
              })
              : buildNoKoneksi()
      )
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
              onPressed: onRefresh,
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
                onPressed: onRefresh,
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }

  Future<void> _CekDurasiPlayYoutube(String id, String YtId) async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_learning_resource');
    String? durasiPutarYoutube = preferences.getString('durasi_putar_youtube_learning_resource');
    if(idYoutube != null && durasiPutarYoutube != null) {
      var response = await LearningResourceService().DurationPlayLearningResouce(
          idSiswa, idYoutube, durasiPutarYoutube);
      _eventClickModel = response;
      if (_eventClickModel.code == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_learning_resource");
        preferences.remove("durasi_putar_youtube_learning_resource");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayYoutubeVideoWidget(jenis: "learning_resource",
                    id: id,
                    youtubeId:YtId)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlayYoutubeVideoWidget(jenis: "learning_resource",
                  id: id,
                  youtubeId:YtId)));
    }
  }
}
