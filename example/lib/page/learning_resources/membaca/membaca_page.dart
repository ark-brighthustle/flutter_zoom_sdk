import 'package:flutter/material.dart';

import '../../../services/classroom/mapel_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/padding.dart';
import 'detail_membaca_page.dart';

class MembacaPage extends StatefulWidget {
  final String title;
  const MembacaPage({Key? key, required this.title}) : super(key: key);

  @override
  State<MembacaPage> createState() => _MembacaPageState();
}

class _MembacaPageState extends State<MembacaPage> {
  int topikId = 1;
  int categoryId = 2;
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
    return Expanded(
      child: ListView.builder(
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
                            builder: (context) => DetailMembacaPage(
                                topikId: topikId,
                                categoryId: categoryId,
                                title: widget.title,
                                mapelId: listMapel[i].id,
                                namaMapel: listMapel[i].namaPelajaran))),
                    leading: Image.asset(
                      "assets/icon/membaca.png",
                      width: 36,
                    ),
                    title: Text(
                      "${listMapel[i].namaPelajaran}",
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
    );
  }
}
