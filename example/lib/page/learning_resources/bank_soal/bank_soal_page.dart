import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/classroom/event_click_model.dart';
import '../../../services/learning_resources/bank_soal_service.dart';
import '../../../services/learning_resources/learning_resource_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/padding.dart';
import '../../../widget/open_pdf_widget.dart';

class BankSoalPage extends StatefulWidget {
  final String title;
  final String id_mapel;
  final String mapel;
  const BankSoalPage({Key? key, required this.id_mapel, required this.mapel, required this.title}) : super(key: key);

  @override
  State<BankSoalPage> createState() => _BankSoalPageState();
}

class _BankSoalPageState extends State<BankSoalPage> {
  List _bankSoalList = [];
  bool isLoading = true;

  getBankSoal() async {
    setState((){
      isLoading = true;
    });
    final response = await BankSoalService().getDataBankSoal(widget.id_mapel);
    if (!mounted) return;
    setState(() {
      _bankSoalList = response;
      isLoading = false;
    });
  }

  Future onRefresh() async {
    await getBankSoal();
  }

  @override
  void initState() {
    getBankSoal();
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

  Widget buildHeader() {
    String title = "Bank Soal";
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
                  "${title}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: padding),
                    child: Image.asset(
                      "assets/icon/bank_soal.png",
                      width: 36,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Text(
                        "${widget.mapel}",
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

  Widget iconButtonBack() {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          size: 20,
        ));
  }

  Widget buildListItem() {
    return Expanded(
        child: RefreshIndicator(
            onRefresh: onRefresh,
            color: kCelticBlue,
            child: isLoading == true
                ? Center(child: CircularProgressIndicator())
                : Stack(
              children: [
                ListView.builder(
                    itemCount: _bankSoalList.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        child: ExpansionPanelList(
                          animationDuration: const Duration(milliseconds: 700),
                          children: [
                            ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return ListTile(
                                  title: Text(
                                    "${_bankSoalList[i].kodeSoal}",
                                  ),
                                  subtitle: Text("${_bankSoalList[i].materiPokok}"),
                                );
                              },
                              body: Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(4, 16, 0, 8),
                                          child: Text("File Soal"),
                                        ),
                                        _bankSoalList[i].fileSoal == null
                                            ? const Text("Tidak Ada")
                                            : Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: TextButton(
                                              onPressed: () => eventClick(_bankSoalList[i]
                                                  .id.toString(),_bankSoalList[i]
                                                  .fileSoal),
                                              child: const Text("Lihat")),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(4, 8, 0, 8),
                                          child: Text("Video"),
                                        ),
                                        _bankSoalList[i].fileVideo == null
                                            ? const Padding(
                                          padding: EdgeInsets.only(right: padding),
                                          child: Text("-"),
                                        )
                                            : TextButton(
                                            onPressed: () => _CekDurasiVideo(_bankSoalList[i].id.toString(), _bankSoalList[i].fileVideo.toString()),
                                            child: const Text("Nonton")),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              isExpanded: _expanded,
                              canTapOnHeader: true,
                            ),
                          ],
                          dividerColor: Colors.grey,
                          expansionCallback: (panelIndex, isExpanded) {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                      );
                    }),
                buildNoData()
              ],
            )
        )
    );
  }

  bool _expanded = false;

  Widget buildNoData() {
    if (_bankSoalList.length == 0) {
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
              )
            ]),
      );
    }else{
      return Container();
    }
  }


  Future<void> _CekDurasiVideo(String idBankSoal, String UrlVideo) async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idVideo = preferences.getString('id_video_bank_soal');
    String? durasiPutar = preferences.getString('durasi_video_bank_soal');
    if(idVideo != null && durasiPutar != null) {
      var response = await BankSoalService().DurationPlayVideoBankSoal(idSiswa, idVideo, durasiPutar);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_video_bank_soal");
          preferences.remove("durasi_video_bank_soal");
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VideoBankSoalPage(
                          id: idBankSoal,
                          fileVideo:UrlVideo.toString())));*/
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_video_bank_soal");
        preferences.remove("durasi_video_bank_soal");
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VideoBankSoalPage(
                        id: idBankSoal,
                        fileVideo:UrlVideo.toString())));*/
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
      }
    }else{
      /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VideoBankSoalPage(
                      id: idBankSoal,
                      fileVideo:UrlVideo.toString())));*/
    }
  }

  Future<void> eventClick(String id, String urlFile) async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    var response = await BankSoalService().eventClick(idSiswa,id);
    _eventClickModel = response;
    if(_eventClickModel.code == 200){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OpenPdfWidget(
                      urlFilePdf:urlFile)));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung keserver")));
    }
  }
}