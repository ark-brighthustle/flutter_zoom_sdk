import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/classroom/event_click_model.dart';
import '../../../services/classroom/mapel_service.dart';
import '../../../services/learning_resources/learning_resource_service.dart';
import '../../../theme/colors.dart';
import '../../../widget/play_youtube_video_widget.dart';
import 'detail-menonton_page.dart';

class MenontonPage extends StatefulWidget {
  final String title;
  const MenontonPage({Key? key, required this.title}) : super(key: key);

  @override
  State<MenontonPage> createState() => _MenontonPageState();
}

class _MenontonPageState extends State<MenontonPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, size: 20, color: kWhite,)),
            bottom: const PreferredSize(
              preferredSize: Size(120, 40),
              child: SizedBox(
                child: TabBar(
                  indicatorColor: kWhite, 
                  labelColor: kWhite,
                  tabs: [
                  SizedBox(
                    height: 48,
                    child: Tab(
                      text: 'Non Umum', 
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: Tab(
                      text: 'Umum',
                    ),
                  )
                ]),
              ),
            ),
          ),
          body: const TabBarView(children: <Widget>[NonUmumView(), UmumView()]),
        ));
  }
}

class NonUmumView extends StatefulWidget {
  const NonUmumView({Key? key}) : super(key: key);

  @override
  State<NonUmumView> createState() => _NonUmumViewState();
}

class _NonUmumViewState extends State<NonUmumView> {
  String title = "Non Umum";
  int topikId = 2;
  int categoryId = 1;
  List listMapel = [];

  Future getMapel() async {
    var response = await MapelService().getDataMapel();
    if (!mounted) return;
    setState(() {
      listMapel = response;
    });
  }

  @override
  void initState() {
    getMapel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
        body: ListView.builder(
            itemCount: listMapel.length,
            itemBuilder: (context, i) {
              return Container(
              color: kWhite,
              child: Column(
              children: [
                ListTile(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailMenontonPage(
                                topikId: topikId,
                                categoryId: categoryId,
                                title: title,
                                mapelId: listMapel[i].id,
                                namaMapel: listMapel[i].namaPelajaran))),
                  leading: Image.asset("assets/icon/menonton.png", width: 36,),
                  title: Text("${listMapel[i].namaPelajaran}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12,),
                ),
                const Divider(thickness: 1,)
              ],
          ),
            );
            }));
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
      if(response != null && response != "Tidak ditemukan"){
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
        }
      }else if(response == "Tidak ditemukan"){
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
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

class UmumView extends StatefulWidget {
  const UmumView({Key? key}) : super(key: key);

  @override
  State<UmumView> createState() => _UmumViewState();
}

class _UmumViewState extends State<UmumView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kGrey,
    );
  }
}