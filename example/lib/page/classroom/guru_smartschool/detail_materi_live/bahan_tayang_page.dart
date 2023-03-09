import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BahanTayangPage extends StatefulWidget {
  final String bahanTayang;
  const BahanTayangPage({Key? key, required this.bahanTayang}) : super(key: key);

  @override
  State<BahanTayangPage> createState() => _BahanTayangPageState();
}

class _BahanTayangPageState extends State<BahanTayangPage> {
   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

    @override
  void initState() {
    _pdfViewerKey.currentState?.openBookmarkView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SfPdfViewer.network(widget.bahanTayang, key: _pdfViewerKey,),
        ),
      ),
    );
  }
}