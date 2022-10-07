import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/learning_resources/learning_resource_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/padding.dart';

// ignore: must_be_immutable
class DetailMembacaPage extends StatefulWidget {
  int? topikId;
  int? categoryId;
  String? title;
  int? mapelId;
  String? namaMapel;
  DetailMembacaPage(
      {Key? key,
      required this.topikId,
      required this.categoryId,
      required this.title,
      required this.mapelId,
      required this.namaMapel})
      : super(key: key);

  @override
  State<DetailMembacaPage> createState() => _DetailMembacaPageState();
}

class _DetailMembacaPageState extends State<DetailMembacaPage> {
  List listLearningResource = [];

  getLearningResource() async {
    final response = await LearningResourceService().getDataLearningResource(
        widget.topikId.toString(),
        widget.categoryId.toString(),
        widget.mapelId.toString());
    if (!mounted) return;
    setState(() {
      listLearningResource = response;
    });
  }

  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  void initState() {
    getLearningResource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            listLearningResource.isNotEmpty
                ? buildListItem()
                : buildNoData(size)
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
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  "${widget.title}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: padding),
                    child: Image.asset(
                      "assets/icon/membaca.png",
                      width: 36,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Text(
                        "${widget.namaMapel}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListItem() {
    return Expanded(
      child: ListView.builder(
          itemCount: listLearningResource.length,
          itemBuilder: (context, i) {
            return Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: kWhite),
              child: ListTile(
                onTap: () =>
                    _launchUrl(Uri.parse("${listLearningResource[i].fileUrl}")),
                leading: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 36,
                    color: kRed,
                  ),
                ),
                title: Text(
                  "${listLearningResource[i].judul}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
            );
          }),
    );
  }

  Widget buildNoData(Size size) {
    return Expanded(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          )
        ]),
      ),
    );
  }
}
