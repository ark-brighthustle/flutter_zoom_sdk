import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/character/amaliah_personal/amaliah_personal_model.dart';
import '../../models/character/amaliah_personal/amaliah_personal_success_model.dart';
import '../../models/classroom/event_click_model.dart';
import '../../services/character/character_amaliah_personal.dart';
import '../../services/character/character_service.dart';
import '../../theme/colors.dart';

import '../../theme/padding.dart';
import '../../utils/constant.dart';
import '../../widget/open_pdf_widget.dart';
import '../../widget/play_youtube_video_widget.dart';
import 'video_amaliah_personal.dart';

class SmartAmaliah extends StatefulWidget{
  final String? idSiswa;
  final String? idIdentitasSekolah;

  const SmartAmaliah({Key? key, required this.idSiswa, required this.idIdentitasSekolah}) : super(key: key);

  @override
  State<SmartAmaliah> createState() => _SmartAmaliahState();
}

class _SmartAmaliahState extends State<SmartAmaliah> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _controllerTopik = TextEditingController();
  final TextEditingController _controllerKeterangan = TextEditingController();

  AmaliahPersonalModel? amaliahPersonalData;
  AmaliahPersonalSuccessModel? amaliahPersonalSuccessData;

  PlatformFile? pickedFile;

  List ListAmaliahPersonal = [];
  List ListAmaliahReference = [];
  bool isLoadingPersonal = true;
  bool isLoadingReference = true;
  bool cekKoneksiPersonal = true;
  bool cekKoneksiReference = true;

  Future _getAmaliahPersonalResource() async {
    setState(() {
      isLoadingPersonal = true;
      cekKoneksiPersonal = true;
    });
    var response = await CharacterAmaliahPersonal().getPesonalAmaliah(widget.idIdentitasSekolah.toString(),widget.idSiswa.toString());
    if(response != null){
      if (!mounted) return;
      setState(() {
        ListAmaliahPersonal = response;
        isLoadingPersonal = false;
        cekKoneksiPersonal = true;
      });
    }else{
      setState(() {
        isLoadingPersonal = false;
        cekKoneksiPersonal = false;
      });
    }
  }

  Future _getAmaliahReferenceResource() async {
    setState(() {
      isLoadingReference = true;
      cekKoneksiReference = true;
    });
    var response = await CharacterService().getAmaliahReferensi(widget.idIdentitasSekolah.toString());
    if(response != null){
      if (!mounted) return;
      setState(() {
        ListAmaliahReference = response;
        isLoadingReference = false;
        cekKoneksiReference = true;
      });
    }else{
      setState(() {
        isLoadingReference = false;
        cekKoneksiReference = false;
      });
    }
  }

  Future refreshAmaliahPersonal() async {
    await _getAmaliahPersonalResource();
  }

  Future refreshAmaliahReference() async {
    await durasiPlayYoutube();
    await _getAmaliahReferenceResource();
  }

  @override
  void initState() {
    super.initState();
    durasiPlayYoutube();
    _getAmaliahPersonalResource();
    _getAmaliahReferenceResource();
  }

  durasiPlayYoutube() async{
    bool playYoutube = await _CekDurasiPlayYoutube();
    if(playYoutube != true){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
    }
  }

  Future<bool> _CekDurasiPlayYoutube() async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_character_referensi');
    String? durasiPutarYoutube = preferences.getString('durasi_putar_youtube_character_referensi');
    if(idYoutube != null && durasiPutarYoutube != null) {
      var response = await CharacterAmaliahPersonal().DurationPlayReferensi(
          idSiswa, idYoutube, durasiPutarYoutube);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_youtube_character_referensi");
          preferences.remove("durasi_putar_youtube_character_referensi");
          return true;
        }else{
          return false;
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_character_referensi");
        preferences.remove("durasi_putar_youtube_character_referensi");
        return true;
      }else{
        return false;
      }
    }else{
     return true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: itemAmaliah(),
      )),
    );
  }

  showAlertDialogLoading(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 15),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void uploadFile() async{
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'pdf'],
    );
    if(result != null){
      setState((){
        pickedFile = result.files.first;
      });
    }
  }

  Widget itemAmaliah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(padding),
          child: Row(
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_rounded, size: 20,)),
              Padding(
                padding: EdgeInsets.only(left: padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(titleSmartKarakter, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    Visibility(
                      visible: true,
                      child: Text(
                        "Amaliah Keagamaan",
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Align(
              alignment: Alignment.center,
              child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    backgroundColor: kGrey,
                    appBar: AppBar(
                      backgroundColor: kGrey,
                      bottom: PreferredSize(
                        preferredSize: const Size(0, 0),
                        child: TabBar(
                            indicatorColor: Color(0xFF047480),
                            labelColor: Color(0xFF047480),
                            tabs: const [
                              SizedBox(
                                height: 48,
                                child: Tab(
                                  text: 'Personal',
                                ),
                              ),
                              SizedBox(
                                height: 48,
                                child: Tab(
                                  text: 'Referensi',
                                ),
                              )
                            ]),
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: TabBarView(children: <Widget>[TabPersonal(), TabReferensi()]),
                    ),
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget TabPersonal(){
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: itemAmaliahPersonal(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _bottomSheetTambahPersonal,
        backgroundColor: Color(0xFF047480),
        child: const Icon(Icons.file_copy_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget itemAmaliahPersonal() {
    return RefreshIndicator(
      onRefresh: refreshAmaliahPersonal,
      color: kCelticBlue,
        child: cekKoneksiPersonal == true
            ? isLoadingPersonal == true
              ? Center(child: CircularProgressIndicator(),)
              : ListAmaliahPersonal.length == 0
                ? buildNoDataPersonal()
                : ListView.builder(
            itemCount: ListAmaliahPersonal.length,
            itemBuilder: (context, i) {
              DateTime dateTime =
              DateTime.parse(ListAmaliahPersonal[i].created_at);
              String createdAt =
              DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
              return Column(
                  children: [
                    if(ListAmaliahPersonal[i].file_type == "mp4")...[
                      // GestureDetector(
                      //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChewieWidget(videoPlayerController: VideoPlayerController.network(ListAmaliahPersonal[i].file),looping: false,))),
                      //   child: Card(
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         SizedBox(
                      //           width: double.infinity,
                      //           height: 168,
                      //           child: Stack(
                      //             children: [
                      //               ClipRRect(
                      //                 child: CachedNetworkImage(
                      //                   width: double.infinity,
                      //                   fit: BoxFit.cover,
                      //                   imageUrl:
                      //                   "https://img.youtube.com/vi/$ytId/0.jpg",
                      //                   errorWidget: (context, url, error) =>
                      //                   const Icon(Icons.error),
                      //                 ),
                      //               ),
                      //               Align(
                      //                   alignment: Alignment.center,
                      //                   child: Icon(
                      //                     Icons.play_circle,
                      //                     size: 60,
                      //                     color: kBlack.withOpacity(0.5),
                      //                   ))
                      //             ],
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(bottom: 16.0, top: 10.0, left: 16.0, right: 16.0),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(createdAt),
                      //               Padding(
                      //                   padding: const EdgeInsets.only(top: 5.0),
                      //                   child: Text(ListAmaliahPersonal[i].topic,
                      //                       style: const TextStyle(
                      //                         fontWeight: FontWeight.w700,
                      //                       ))),
                      //               Padding(
                      //                   padding: const EdgeInsets.only(top: 5.0),
                      //                   child: ListAmaliahPersonal[i].description != null
                      //                       ? Text("${ListAmaliahPersonal[i].description}")
                      //                       : null
                      //               )
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // )
                      GestureDetector(
                          onTap: () => showModalBottomView(ListAmaliahPersonal[i].id.toString(),widget.idIdentitasSekolah.toString(),"mp4",ListAmaliahPersonal[i].file),
                          child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: padding),
                                child: ListTile(
                                  leading:  Image.asset(
                                    'assets/icon/mp4.png',
                                  ),
                                  title: Text(ListAmaliahPersonal[i].topic,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      )),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: ListAmaliahPersonal[i].description != null
                                              ? Text("${ListAmaliahPersonal[i].description}", style: TextStyle(color: Colors.black),)
                                              : null
                                      ),
                                      SizedBox(
                                        height: 12.0,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(createdAt, style: TextStyle(fontSize: 13, color: Colors.black),),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          )
                      )
                    ]else if(ListAmaliahPersonal[i].file_type == "pdf")...[
                      GestureDetector(
                          onTap: () => showModalBottomView(ListAmaliahPersonal[i].id.toString(),widget.idIdentitasSekolah.toString(),"pdf",ListAmaliahPersonal[i].file),
                          child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: padding),
                                child: ListTile(
                                  leading:  Image.asset(
                                    'assets/icon/pdf.png',
                                  ),
                                  title: Text(ListAmaliahPersonal[i].topic,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      )),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: ListAmaliahPersonal[i].description != null
                                              ? Text("${ListAmaliahPersonal[i].description}", style: TextStyle(color: Colors.black),)
                                              : null
                                      ),
                                      SizedBox(
                                        height: 12.0,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(createdAt, style: TextStyle(fontSize: 13, color: Colors.black),),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          )
                      )
                    ]else if(ListAmaliahPersonal[i].file_type == "mp3")...[
                      GestureDetector(
                          onTap: () => showModalBottomView(ListAmaliahPersonal[i].id.toString(),widget.idIdentitasSekolah.toString(),"mp3",ListAmaliahPersonal[i].file),
                          child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: padding),
                                child: ListTile(
                                  leading:  Image.asset(
                                    'assets/icon/mp3.png',
                                  ),
                                  title: Text(ListAmaliahPersonal[i].topic,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      )),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: ListAmaliahPersonal[i].description != null
                                              ? Text("${ListAmaliahPersonal[i].description}", style: TextStyle(color: Colors.black),)
                                              : null
                                      ),
                                      SizedBox(
                                        height: 12.0,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(createdAt, style: TextStyle(fontSize: 13, color: Colors.black),),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          )
                      )
                    ]
                  ]);
            })
            : buildNoKoneksiPersonal()
    );
  }

  Widget buildNoDataPersonal() {
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
              onPressed: refreshAmaliahPersonal,
              child: Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
    );
  }

  Widget buildNoKoneksiPersonal() {
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
                onPressed: refreshAmaliahPersonal,
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }

  _bottomSheetTambahPersonal() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, setState){
                return SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                              child: Container(
                                  height: 8.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(const Radius.circular(80.0))))
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,left: 23.0,right: 23.0,top: 23.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Text(
                                    'Topik',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Card(
                                  elevation: 1.0,
                                  margin: EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 5.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0,),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/icon/label.png",
                                          color: Colors.grey,
                                          width: 18,
                                          height: 18,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _controllerTopik,
                                            keyboardType: TextInputType.text,
                                            autofocus: false,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                                              hintText: "Masukkan Topik",
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            autovalidateMode: AutovalidateMode.always,
                                            autocorrect: false,
                                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return "Topik tidak boleh kosong";
                                              }else{
                                                return null;
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 10.0,
                                  ),
                                  child: Text(
                                    'File',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Card(
                                  elevation: 1.0,
                                  margin: EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 5.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0,),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: uploadFile,
                                            child: Row(
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/icon/upload.png",
                                                  color: Colors.grey,
                                                  width: 18,
                                                  height: 18,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Text("Upload File",style: TextStyle(
                                                  color: Colors.grey,
                                                ),),
                                                if(pickedFile != null)...[//Conditionally widget(s) here
                                                  Flexible(child: Padding(
                                                    padding: EdgeInsets.only(left: 10.0),
                                                    child: Text(pickedFile!.name.toString(), style: TextStyle(
                                                        color: Colors.black,fontStyle: FontStyle.italic
                                                    ),overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text("File mp3, mp4, pdf",style: TextStyle(
                                  color: Colors.grey,fontStyle: FontStyle.italic
                                ),),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 15.0,
                                  ),
                                  child: Text(
                                    'Deskripsi',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Card(
                                  elevation: 1.0,
                                  margin: EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 5.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0,),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/icon/text.png",
                                          color: Colors.grey,
                                          width: 18.0,
                                          height: 18.0,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _controllerKeterangan,
                                            keyboardType: TextInputType.text,
                                            maxLines: 4,
                                            maxLength: 100,
                                            autofocus: false,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                                              hintText: "Masukkan Deskripsi",
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            autovalidateMode: AutovalidateMode.always,
                                            autocorrect: false,
                                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return "Deskripsi tidak boleh kosong";
                                              }else{
                                                return null;
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                    ),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(24))),
                                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF047480)),
                                        ),
                                        onPressed: submitDataAmaliahPribadi,
                                        child: const SizedBox(
                                            width: double.infinity,
                                            height: 48,
                                            child: Center(
                                                child: Text(
                                                  "Simpan",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ))))
                                )
                              ],
                            ),
                          )
                        ),
                      ]),
                );
              }
          );
        });
  }

  submitDataAmaliahPribadi() async{
    if(pickedFile != null) {
      showAlertDialogLoading(context);
      var response = await CharacterAmaliahPersonal().tambahPersonalAmaliah(widget.idIdentitasSekolah.toString(),widget.idSiswa.toString(),_controllerTopik.text.toString(),File(pickedFile!.path!),_controllerKeterangan.text.toString());

      if(response != null){
        setState((){
          amaliahPersonalSuccessData = response.data;
        });

        if(response.data != null) {
          _controllerTopik.clear();
          pickedFile = null;
          _controllerKeterangan.clear();
          Navigator.pop(context);
          Navigator.of(context).pop();
          refreshAmaliahPersonal();
          alertDialogMessage("menambah","amaliah keagamaan personal");
        }else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
        }
      }else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }
    }
  }

  Widget TabReferensi(){
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: itemAmaliahReference(),
      )),
    );
  }

  Widget itemAmaliahReference() {
    return RefreshIndicator(
        onRefresh: refreshAmaliahReference,
        color: kCelticBlue,
        child: cekKoneksiReference == true
            ? isLoadingReference == true
                ? Center(child: CircularProgressIndicator(),)
                : ListAmaliahReference.length == 0
                  ? buildNoDataReference()
                  : ListView.builder(
            itemCount: ListAmaliahReference.length,
            itemBuilder: (context, i) {
              String ytId = ListAmaliahReference[i].reference_url.substring(32, 43);
              DateTime dateTime =
              DateTime.parse(ListAmaliahReference[i].created_at);
              String createdAt =
              DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
              return GestureDetector(
                onTap: () { _CekDurasiPlayYoutube2(ListAmaliahReference[i].id.toString(), ytId);},
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 168,
                        child: Stack(
                          children: [
                            ClipRRect(
                              child: CachedNetworkImage(
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl:
                                "https://img.youtube.com/vi/$ytId/0.jpg",
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.play_circle,
                                  size: 60,
                                  color: kBlack.withOpacity(0.5),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 10.0, left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(createdAt),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(ListAmaliahReference[i].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ))),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: ListAmaliahReference[i].description != null
                                    ? Text("${ListAmaliahReference[i].description}")
                                    : null
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            : buildNoKoneksiReference()
    );
  }

  Widget buildNoDataReference() {
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
              onPressed: refreshAmaliahReference,
              child: Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
    );
  }

  Widget buildNoKoneksiReference() {
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
                onPressed: refreshAmaliahReference,
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }

  Future<void> _CekDurasiPlayYoutube2(String id, String YtId) async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_character_referensi');
    String? durasiPutarYoutube = preferences.getString('durasi_putar_youtube_character_referensi');
    if(idYoutube != null && durasiPutarYoutube != null) {
      var response = await CharacterAmaliahPersonal().DurationPlayReferensi(
          idSiswa, idYoutube, durasiPutarYoutube);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_youtube_character_referensi");
          preferences.remove("durasi_putar_youtube_character_referensi");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayYoutubeVideoWidget(jenis: "character_referensi",id: id,
                      youtubeId: YtId)));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_character_referensi");
        preferences.remove("durasi_putar_youtube_character_referensi");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayYoutubeVideoWidget(jenis: "character_referensi",id: id,
                    youtubeId: YtId)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
      }
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlayYoutubeVideoWidget(jenis: "character_referensi",id: id,
                  youtubeId: YtId)));
    }
  }

  showModalBottomView(String id, String idSekolah, String typefile, String file){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if(typefile == "mp4" || typefile == "pdf")...[
                ListTile(
                  leading: new Icon(Icons.file_present_rounded),
                  title: new Text('Lihat File'),
                  onTap: () {
                    if(typefile == "mp4"){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VideoAmaliahPersonalPage(
                          fileVideo:file)));
                    }else if(typefile == "pdf"){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OpenPdfWidget(
                                      urlFilePdf: file)));
                    }
                  },
                )
              ],
              ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Hapus'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Hapus"),
                          content: Text(
                              "Apakah Anda yakin ingin menghapus?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => hapusDataAmaliahPribadi(id,idSekolah),
                              child: const Text("Hapus"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Batal"),
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          );
        });
  }

  hapusDataAmaliahPribadi(String id, String idSekolah) async{
    Navigator.pop(context);
    if(id != null) {
      showAlertDialogLoading(context);
      var response = await CharacterAmaliahPersonal().hapusPersonalAmaliah(id,idSekolah);
      if(response != null){
        if(response['success'] == true) {
          Navigator.pop(context);
          refreshAmaliahPersonal();
          alertDialogMessage("hapus","amaliah keagamaan personal");
        }else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
        }
      }else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }
    }
  }

  alertDialogMessage(String action,String data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(
              Icons.check_circle_rounded,
              color: kGreen,
              size: 36,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text("Berhasil "+action+" "+data)],
            ),
          );
        });
  }
}