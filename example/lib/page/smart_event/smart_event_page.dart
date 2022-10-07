import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import 'kompetisi_page.dart';
import 'podcast_page.dart';
import 'talkshow_page.dart';
import 'workshop_page.dart';

class SmartEventPage extends StatefulWidget {
  final String idSiswa;
  const SmartEventPage({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<SmartEventPage> createState() => _SmartEventPageState();
}

class _SmartEventPageState extends State<SmartEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      appBar: AppBar(
        title: const Text(titleSmartEvent),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(padding),
        child: kategoriEvent(),
      ),
    );
  }

  Widget kategoriEvent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => KompetisiPage(idSiswa: widget.idSiswa))),
            child: Image.asset("assets/event/kompetisi.png",)),
          const SizedBox(height: 16,),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PodcastPage())),
            child: Image.asset("assets/event/podcast.png",)),
          const SizedBox(height: 16,),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TalkshowPage())),
            child: Image.asset("assets/event/talkshow.png",)),
          const SizedBox(height: 16,),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkshopPage())),
            child: Image.asset("assets/event/workshop.png",)),
        ],
      ),
    );
  }
}
