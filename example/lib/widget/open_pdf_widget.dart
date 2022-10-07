import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenPdfWidget extends StatefulWidget {
  final String urlFilePdf;
  const OpenPdfWidget({Key? key, required this.urlFilePdf}) : super(key: key);

  @override
  State<OpenPdfWidget> createState() => _OpenPdfWidgetState();
}

class _OpenPdfWidgetState extends State<OpenPdfWidget> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerKey.currentState?.openBookmarkView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SfPdfViewer.network(widget.urlFilePdf, key: _pdfViewerKey,),
        ),
      ),
    );
  }
}