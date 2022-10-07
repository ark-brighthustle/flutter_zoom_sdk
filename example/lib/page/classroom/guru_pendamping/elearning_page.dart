import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/theme/colors.dart';
import 'package:flutter_zoom_sdk_example/theme/padding.dart';

import '../../../services/classroom/category_elearning_service.dart';
import 'bahan/bahan_elearning_page.dart';
import 'tugas/tugas_elearning_page.dart';
import 'ujian/ujian_elearning_page.dart';

class ElearningPage extends StatefulWidget {
  final int kodeJadwal;
  final String hari;
  final int jamKe;
  final String mapel;
  final String jamMulai;
  final String jamSelesai;
  const ElearningPage(
      {Key? key,
      required this.kodeJadwal,
      required this.hari,
      required this.jamKe,
      required this.mapel,
      required this.jamMulai,
      required this.jamSelesai})
      : super(key: key);

  @override
  State<ElearningPage> createState() => _ElearningPageState();
}

class _ElearningPageState extends State<ElearningPage> {
  List listElearning = [];

  Future getCategoryElearning() async {
    var response = await CategoryElearningService().getDataCategoryElearning();
    if (!mounted) return;
    setState(() {
      listElearning = response;
    });
  }

  @override
  void initState() {
    getCategoryElearning();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(vertical: padding),
          child: Column(
            children: [buildHeader(), buildItemElearning()],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: kCelticBlue,
                    )),
                const SizedBox(
                  width: 8,
                ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: kBlack.withOpacity(0.1),
                ),
                child: Text(
                  widget.hari,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              widget.mapel,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Image.asset(
                  "assets/icon/clock.png",
                  width: 20,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text("${widget.jamMulai} - ${widget.jamSelesai}")
            ],
          )
        ],
      ),
    );
  }

  Widget buildItemElearning() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: GridView.builder(
          itemCount: listElearning.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 2.5, crossAxisCount: 1, mainAxisSpacing: 12),
          itemBuilder: (context, i) {
            String idLink = listElearning[i].image.substring(32, 65);
            return GestureDetector(
              onTap: () {
                if (listElearning[i].id == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BahanElearningPage(
                              id: listElearning[i].id,
                              namaKategori: listElearning[i].namaKategori)));
                } else if (listElearning[i].id == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TugasElearningPage(
                              id: listElearning[i].id,
                              namaKategori: listElearning[i].namaKategori)));
                } else if (listElearning[i].id == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UjianElearningPage(
                              kodeJadwal: widget.kodeJadwal,
                              id: listElearning[i].id,
                              namaKategori: listElearning[i].namaKategori)));
                }
              },
              child: SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://drive.google.com/uc?export=download&id=$idLink",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Gagal Memuat Gambar!",
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
    ));
  }
}
