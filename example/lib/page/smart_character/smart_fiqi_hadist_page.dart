import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/character/character_service.dart';
import '../../theme/colors.dart';
import '../../theme/material_colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';

class SmartFiqiHadist extends StatefulWidget{
  final String? idSiswa;

  const SmartFiqiHadist({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<SmartFiqiHadist> createState() => _DetailSmartFiqiHadistState();
}

class _DetailSmartFiqiHadistState extends State<SmartFiqiHadist> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: itemFiqiHadist(),
      )),
    );
  }

  Widget itemFiqiHadist() {
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
                        "Fiqih dan Hadist",
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
                            indicatorColor: colorCelticBlue,
                            labelColor: colorCelticBlue,
                            tabs: const [
                              SizedBox(
                                height: 48,
                                child: Tab(
                                  text: 'Fiqih',
                                ),
                              ),
                              SizedBox(
                                height: 48,
                                child: Tab(
                                  text: 'Hadist',
                                ),
                              )
                            ]),
                      ),
                    ),
                    body: Padding(
                    padding: const EdgeInsets.all(padding),
                        child: TabBarView(children: <Widget>[FiqihView(idSiswa: widget.idSiswa), HadistView(idSiswa: widget.idSiswa)]),
                    ),
                  )
              )
          ),
        ),
      ],
    );
  }
}

class FiqihView extends StatefulWidget {
  final String? idSiswa;

  const FiqihView({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<FiqihView> createState() => _FiqihViewState();
}

class _FiqihViewState extends State<FiqihView> {

  List Fiqihlist = [];

  Future _getFiqihResource() async {
    var response = await CharacterService().getDataFiqih(widget.idSiswa.toString());
    if (!mounted) return;
    setState(() {
      Fiqihlist = response;
    });
  }

  Future refreshFiqih() async {
    _getFiqihResource();
  }

  @override
  void initState() {
    _getFiqihResource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: itemFiqihList()
    );
  }

  Widget itemFiqihList() {
    return RefreshIndicator(
        onRefresh: refreshFiqih,
        color: kCelticBlue,
        child: ListView.builder(
            itemCount: Fiqihlist.length,
            itemBuilder: (context, i) {
              DateTime dateTime =
              DateTime.parse(Fiqihlist[i].created_at);
              String createdAt =
              DateFormat('dd/MM/yyyy hh:mm').format(dateTime);
              return Card(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 2.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Topik',
                                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  child: Text(
                                    createdAt,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Fiqihlist[i].topik,
                                style: const TextStyle(fontWeight: FontWeight.w600,),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Amalan : ${Fiqihlist[i].amalan}\nHafalan : ${Fiqihlist[i].hafalan}',
                                          style: TextStyle(color: Colors.black.withOpacity(0.6),),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0, bottom: 16.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Keterangan',
                                style: TextStyle(color: Colors.black.withOpacity(0.5),),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Fiqihlist[i].keterangan != null
                                    ? Text(
                                  '${Fiqihlist[i].keterangan}',
                                  style: TextStyle(color: Colors.black.withOpacity(0.6),),
                                )
                                    : Text(
                                  '-',
                                  style: TextStyle(color: Colors.black.withOpacity(0.6),),
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}

class HadistView extends StatefulWidget {
  final String? idSiswa;

  const HadistView({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<HadistView> createState() => _HadistViewState();
}

class _HadistViewState extends State<HadistView> {

  List Hadistlist = [];

  Future _getHadistResource() async {
    var response = await CharacterService().getDataHadist(widget.idSiswa.toString());
    if (!mounted) return;
    setState(() {
      Hadistlist = response;
    });
  }

  Future refreshHadist() async {
    _getHadistResource();
  }

  @override
  void initState() {
    _getHadistResource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kGrey,
        body: itemHadistList()
    );
  }

  Widget itemHadistList() {
    return RefreshIndicator(
        onRefresh: refreshHadist,
        color: kCelticBlue,
        child: ListView.builder(
            itemCount: Hadistlist.length,
            itemBuilder: (context, i) {
              DateTime dateTime =
              DateTime.parse(Hadistlist[i].created_at);
              String createdAt =
              DateFormat('dd/MM/yyyy hh:mm').format(dateTime);
              return Card(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 2.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Hadist ${Hadistlist[i].nama_hadist}, No. ${Hadistlist[i].nomor_hadist}",
                                    style: const TextStyle(fontWeight: FontWeight.w600,),
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  child: Text(
                                    createdAt,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top:8.0, bottom: 16.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Amalan : ${Hadistlist[i].amalan},   Hafalan : ${Hadistlist[i].hafalan}',
                                          style: TextStyle(color: Colors.black.withOpacity(0.6),),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
    );
  }
}