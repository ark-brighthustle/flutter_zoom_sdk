import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatefulWidget {
  final String filePdf;
  const PdfViewerWidget({Key? key, required this.filePdf}) : super(key: key);

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerKey.currentState!.openBookmarkView();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SfPdfViewer.network(widget.filePdf, key: _pdfViewerKey,),
        ),
      ),
    );
  }
}