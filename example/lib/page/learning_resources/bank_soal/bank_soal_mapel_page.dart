import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../services/classroom/mapel_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/padding.dart';
import 'bank_soal_page.dart';

class BankSoalMapelPage extends StatefulWidget {
  final String title;
  const BankSoalMapelPage({Key? key, required this.title}) : super(key: key);

  @override
  State<BankSoalMapelPage> createState() => _BankSoalMapelPageState();
}

class _BankSoalMapelPageState extends State<BankSoalMapelPage> {
  List _matapelajaran = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  getMataPelajaran() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    final response = await MapelService().getDataMapel();
    if(response != null){
      if (!mounted) return;
      setState(() {
        _matapelajaran = response;
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

  Future onRefresh() async {
    await getMataPelajaran();
  }

  @override
  void initState() {
    getMataPelajaran();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                buildListMapel(),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                widget.title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(padding),
              child: Text(
                "Pilih Mata Pelajaran",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildListMapel() {
    String title = "Bank Soal";
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: kCelticBlue,
        child: cekKoneksi == true
          ? isLoading == true
            ? Center(child: CircularProgressIndicator(),)
            : _matapelajaran.length == 0
              ? buildNoData()
              : ListView.builder(
            itemCount: _matapelajaran.length,
            itemBuilder: (context, i) {
              return Container(
                color: kWhite,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BankSoalPage(title: title, mapel: _matapelajaran[i].namaPelajaran,
                        id_mapel: _matapelajaran[i].id.toString(),
                      ))),
                      leading: Image.asset(
                        "assets/icon/bank_soal.png",
                        width: 36,
                      ),
                      title: Text(
                        "${_matapelajaran[i].namaPelajaran}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    )
                  ],
                ),
              );
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
}
