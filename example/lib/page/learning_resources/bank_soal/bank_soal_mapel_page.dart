import 'package:flutter/material.dart';

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

  getMataPelajaran() async {
    final response = await MapelService().getDataMapel();
    if (!mounted) return;
    setState(() {
      _matapelajaran = response;
    });
  }

  Future onRefresh() async {
    await MapelService().getDataMapel();
  }

  Future refreshBankSoalMapel() async {
    await MapelService().getDataMapel();
  }

  @override
  void initState() {
    getMataPelajaran();
    onRefresh();
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
        onRefresh: refreshBankSoalMapel,
        color: kCelticBlue,
        child: ListView.builder(
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
            }),
      )
    );
  }
}
