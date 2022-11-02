import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/theme/colors.dart';
import 'package:flutter_zoom_sdk_example/theme/padding.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailLibraryPage extends StatefulWidget {
  String? imageThumb;
  String? title;
  String? desc;
  String? publisher;
  String? previewLinks;
  String? infoLinks;
  String? webReaderLinks;
  String? printType;
  int? pageCount;
  DetailLibraryPage(
      {Key? key,
      this.imageThumb,
      this.title,
      this.desc,
      this.publisher,
      this.previewLinks,
      this.infoLinks,
      this.webReaderLinks,
      this.printType,
      this.pageCount,})
      : super(key: key);

  @override
  State<DetailLibraryPage> createState() => _DetailLibraryPageState();
}

class _DetailLibraryPageState extends State<DetailLibraryPage> {
  launchPreviewLinks(Uri previewLinks) async {
    if (!await launchUrl(previewLinks)) throw 'Could not launch $previewLinks';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildIconBack(), buildBody(), buildFooter()],
          ),
        ),
      )),
    );
  }

  Widget buildIconBack() {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(left: padding, top: padding),
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
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.all(padding),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network("${widget.imageThumb}"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "${widget.title}",
              style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center,
            ),
          ),
           Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "${widget.publisher}",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: kBlack45, fontSize: 12),
                ),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.book, color: kBlack),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text("${widget.printType}", style: const TextStyle(fontSize: 12),),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("${widget.pageCount}", style: const TextStyle(fontWeight: FontWeight.w500),),
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text('Halaman', style: TextStyle(fontSize: 12),),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              "${widget.desc}",
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Widget buildFooter() {
    return SizedBox(
        child: Row(
      children: [Expanded(child: buildPreview()), buildBuy()],
    ));
  }

  Widget buildPreview() {
    return GestureDetector(
      onTap: () => launchPreviewLinks(Uri.parse("${widget.webReaderLinks}")),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), 
            color: kBlack),
        child: const Center(
            child: Text(
          "Preview",
          style: TextStyle(color: kWhite),
        )),
      ),
    );
  }

  Widget buildBuy() {
    return GestureDetector(
      onTap: () => launchPreviewLinks(Uri.parse("${widget.infoLinks}")),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kGrey.withOpacity(0.7)),
        child: Center(
            child: Row(
          children: const [
            Icon(Icons.shopping_cart),
          ],
        )),
      ),
    );
  }
}
