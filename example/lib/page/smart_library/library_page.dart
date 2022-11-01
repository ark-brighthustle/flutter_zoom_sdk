import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/page/smart_library/detail_library_page.dart';
import 'package:flutter_zoom_sdk_example/services/library/library_service.dart';

import '../../theme/colors.dart';
import '../../utils/constant.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String assetIcon = "assets/icon/coming-soon.png";

  List itemListBook = [];

  getLibraryBook() async {
    final response = await LibraryService().getDatalibraryBook();
    if (!mounted) return;
    setState(() {
      itemListBook = response;
    });
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
      appBar: AppBar(
        title: const Text(titleSmartLibrary),
      ),
      backgroundColor: kGrey,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(8),
        child: buildItemListBook()));
  }

  Widget buildItemListBook() {
    return ListView.builder(
      itemCount: itemListBook.length,
      itemBuilder: (context, i){
      return GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailLibraryPage(
          imageThumb: itemListBook[i].volumeInfo.image.thumb,
          title: itemListBook[i].volumeInfo.title,
          desc: itemListBook[i].volumeInfo.description,
          publisher: itemListBook[i].volumeInfo.publisher,
          previewLinks: itemListBook[i].volumeInfo.previewLinks,
          infoLinks: itemListBook[i].volumeInfo.infoLinks
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
    });
  }
}
