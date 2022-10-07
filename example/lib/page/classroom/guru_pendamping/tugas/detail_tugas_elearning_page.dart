import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/padding.dart';

// ignore: must_be_immutable
class DetailTugasElearningPage extends StatefulWidget {
  final int id;
  final String elearningCategoryId;
  final String namaKategori;
  final int idMataPelajaran;
  final String namaMataPelajaran;
  final String judul;
  final String deskripsi;
  final String fileUrl;
  final String videoUrl;
  final String waktuMulai;
  final String waktuSelesai;
  String? createdAt;
  String? updatedAt;
  DetailTugasElearningPage(
      {Key? key,
      required this.id,
      required this.elearningCategoryId,
      required this.judul,
      required this.deskripsi,
      required this.fileUrl,
      required this.videoUrl,
      required this.waktuMulai,
      required this.waktuSelesai,
      this.createdAt,
      this.updatedAt,
      required this.namaKategori,
      required this.idMataPelajaran,
      required this.namaMataPelajaran})
      : super(key: key);

  @override
  State<DetailTugasElearningPage> createState() =>
      _DetailTugasElearningPageState();
}

class _DetailTugasElearningPageState extends State<DetailTugasElearningPage> {
   void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: kWhite, size: 20,)),
        title: Text("Detail ${widget.namaKategori}", style: const TextStyle(fontSize: 16),),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8),
        child: detailTugas(),
      ),
    );
  }

  Widget detailTugas() {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Mata Pelajaran"),
                    Text(
                      widget.namaMataPelajaran,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Judul"),
                    Text(
                      widget.judul,
                      style: const TextStyle(fontWeight: FontWeight.w600),  
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Deskripsi"),
                    const SizedBox(width: 12,),
                    Flexible(
                      child: Text(
                        widget.deskripsi,
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
                    const Text("File Lampiran"),
                    TextButton(
                        onPressed: () => _launchUrl(Uri.parse(widget.fileUrl)),
                        child: const Text("Lihat"))
                  ],
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => {},
          child: Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.symmetric(vertical: padding),
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://img.youtube.com/vi/${widget.videoUrl.substring(32, 43)}/0.jpg",
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      size: 60,
                      color: kWhite.withOpacity(0.7),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
