import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/classroom/komentar_model.dart';
import '../../../../services/classroom/komentar_service.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/padding.dart';
import '../../../../widget/pdf_viewer_widget.dart';

// ignore: must_be_immutable
class DetailBahanElearningPage extends StatefulWidget {
  final int id;
  final int elearningCategoryId;
  final String namaKategori;
  final int idMataPelajaran;
  final String namaMataPelajaran;
  final String judul;
  final String deskripsi;
  String? fileUrl;
  String? videoUrl;
  String? waktuMulai;
  String? waktuSelesai;
  String? createdAt;
  String? updatedAt;
  DetailBahanElearningPage(
      {Key? key,
      required this.namaKategori,
      required this.id,
      required this.elearningCategoryId,
      required this.judul,
      required this.deskripsi,
      this.fileUrl,
      this.videoUrl,
      this.waktuMulai,
      this.waktuSelesai,
      this.createdAt,
      this.updatedAt,
      required this.idMataPelajaran,
      required this.namaMataPelajaran})
      : super(key: key);

  @override
  State<DetailBahanElearningPage> createState() =>
      _DetailBahanElearningPageState();
}

class _DetailBahanElearningPageState extends State<DetailBahanElearningPage> {
  //late VideoPlayerController _videoPlayerController;
  final TextEditingController _controllerKomentar = TextEditingController();
  int? idSiswa;
  Future<Komentar>? _futureKomentar;
  List listAllKomentar = [];
  int? totalKomentar;

  loadVideoPlayer() {
    /*_videoPlayerController =
        VideoPlayerController.network(widget.videoUrl.toString())
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });*/
  }

  getDataSiswa() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      idSiswa = _preferences.getInt("id_siswa");
    });
  }

  sendDataKomentar() {
    setState(() {
      _futureKomentar = createComment(widget.elearningCategoryId.toString(),
          idSiswa.toString(), _controllerKomentar.text);
    });
  }

  getAllKomentar() async {
    final response = await AllKomentarService()
        .getDataAllKomentar(widget.elearningCategoryId.toString());
    if (!mounted) return;
    setState(() {
      listAllKomentar = response;
    });
  }

  @override
  void initState() {
    loadVideoPlayer();
    getDataSiswa();
    sendDataKomentar();
    getAllKomentar();
    super.initState();
  }

  @override
  void dispose() {
    //_videoPlayerController.dispose();
    _controllerKomentar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: kWhite,
              size: 20,
            )),
        title: Text(
          "Detail ${widget.namaKategori}",
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            widget.videoUrl == null ? Container() : 
            //video(),
            detailBahan(),
          ],
        ),
      ),
    );
  }

  /*Widget video() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          _videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                )
              : Container(),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _videoPlayerController.value.isPlaying
                      ? _videoPlayerController.pause()
                      : _videoPlayerController.play();
                });
              },
              icon: Icon(
                _videoPlayerController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                size: 40,
              ),
              color: kBlack.withOpacity(0.5),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(_videoPlayerController,
                  allowScrubbing: true))
        ],
      ),
    );
  }*/

  Widget detailBahan() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: kWhite,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mata Pelajaran",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                    child: Text(
                      widget.namaMataPelajaran,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Judul",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                    child: Text(
                      widget.judul,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                    child: Text(
                      widget.deskripsi,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              fileLampiran()
            ],
          ),
        ),
        komentar(),
      ],
    );
  }

  Widget fileLampiran() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "File Lampiran",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        widget.fileUrl == null
            ? const Text(
                "Tidak Ada",
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: kRed),
              )
            : TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfViewerWidget(
                            filePdf: widget.fileUrl.toString()))),
                child: const Text(
                  "Lihat",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ))
      ],
    );
  }

  Widget komentar() {
    return GestureDetector(
      onTap: bottomSheetKomentar,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: kWhite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Komentar",
              style: TextStyle(fontSize: 12),
            ),
            Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }

  bottomSheetKomentar() {
    showModalBottomSheet(
        backgroundColor: kWhite,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        isScrollControlled: true,
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.7,
                  child: Stack(
                    children: [
                      //Positioned(right: 0, child: iconClose()),
                      /*Positioned(
                      top: 40,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: FutureBuilder<Komentar>(
                          future: _futureKomentar,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!.comment.toString());
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
          
                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                    ),*/
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: padding),
                                child: Text(
                                  "$totalKomentar Komentar",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              iconClose(),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ListView.builder(
                                  itemCount: listAllKomentar.length,
                                  itemBuilder: (context, i) {
                                    totalKomentar = listAllKomentar.length;
                                    return ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 4),
                                      leading: const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png"),
                                        radius: 16,
                                        backgroundColor: kGrey,
                                      ),
                                      title: listAllKomentar[i].namaSiswa ==
                                              null
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 4),
                                              child: Text(
                                                "Anonim",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Text(
                                                "${listAllKomentar[i].namaSiswa}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${listAllKomentar[i].comment}",
                                            style: const TextStyle(
                                                fontSize: 12, color: kBlack),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "${listAllKomentar[i].createdAt}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              color: kWhite,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png"),
                                    radius: 20,
                                    backgroundColor: kGrey,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    height:
                                        MediaQuery.of(context).size.height / 16,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: kGrey),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: TextFormField(
                                        controller: _controllerKomentar,
                                        style: const TextStyle(fontSize: 12),
                                        decoration: const InputDecoration(
                                            hintText: "Tambahkan komentar...",
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  iconSend()
                                ],
                              )))
                    ],
                  ),
                ),
              );
            }));
  }

  Widget iconClose() {
    return IconButton(
        onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close));
  }

  Widget iconSend() {
    return IconButton(
      onPressed: sendDataKomentar,
      icon: const Icon(
        Icons.send,
      ),
      color: kCelticBlue,
    );
  }
}
