import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileModulPage extends StatefulWidget {
  final String urlFileModul;
  const FileModulPage({Key? key, required this.urlFileModul}) : super(key: key);

  @override
  State<FileModulPage> createState() => _FileModulPageState();
}

class _FileModulPageState extends State<FileModulPage> {
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
          child: SfPdfViewer.network(widget.urlFileModul, key: _pdfViewerKey,),
        ),
      ),
    );
  }
}