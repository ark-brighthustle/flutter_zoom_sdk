import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_sdk_example/page/smart_library/detail_library_page.dart';
import 'package:flutter_zoom_sdk_example/services/library/library_service.dart';

import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String assetIcon = "assets/icon/coming-soon.png";
  List itemListBook = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  Future getLibraryBook() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    final response = await LibraryService().getDatalibraryBook();
    if(response != null){
      if (!mounted) return;
      setState(() {
        itemListBook = response;
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

  Future onRefresh() async{
    await getLibraryBook();
  }

  @override
  void initState() {
    getLibraryBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            buildItemLibrary()
          ],
        )));
  }

  Widget buildIconBack() => Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(left: 8, top: padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kGrey.withOpacity(0.7)),
      child: Center(
        child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
            )),
      ),
    );

  Widget buildTitlePage() => const Padding(padding: EdgeInsets.only(left: 8, top: padding), child: Text(titleSmartLibrary, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),);

  Widget buildHeader() => Container(
    margin: const EdgeInsets.only(top: padding, bottom: padding/4),
    color: kTransparent,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildIconBack(),
        buildTitlePage()
      ],
    ),
  );

  Widget buildItemLibrary() {
    return Expanded(
        child: RefreshIndicator(
            onRefresh: onRefresh,
            color: kCelticBlue,
            child: cekKoneksi == true
              ? isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : itemListBook.isEmpty
                  ? buildNoData()
                  : ListView.builder(
                  itemCount: itemListBook.length,
                  itemBuilder: (context, i){
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailLibraryPage(
                        imageThumb: itemListBook[i].volumeInfo.image.thumb,
                        title: itemListBook[i].volumeInfo.title,
                        desc: itemListBook[i].volumeInfo.description,
                        publisher: itemListBook[i].volumeInfo.publisher,
                        previewLinks: itemListBook[i].volumeInfo.previewLinks,
                        infoLinks: itemListBook[i].volumeInfo.infoLinks,
                        webReaderLinks: itemListBook[i].accessInfo.webReaderLinks,
                        printType: itemListBook[i].volumeInfo.printType,
                        pageCount: itemListBook[i].volumeInfo.pageCount,
                      ))),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kWhite
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network("${itemListBook[i].volumeInfo.image.thumb}")),
                            const SizedBox(width: 8,),
                            Flexible(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text("${itemListBook[i].volumeInfo.title},", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                  ),
                                  Text("${itemListBook[i].volumeInfo.description},", style: const TextStyle(fontSize: 10), maxLines: 5, textAlign: TextAlign.justify,),
                                ],
                              ),
                            )
                          ],
                        ),
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
