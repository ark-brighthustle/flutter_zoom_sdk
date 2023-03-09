import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProgressDownload extends StatefulWidget {
  final String ytId;
  final String videoUrl;
  final String imageUrl;
  final String judul;
  const ProgressDownload({
    Key? key,
    required this.ytId,
    required this.videoUrl,
    required this.imageUrl,
    required this.judul,
  }) : super(key: key);

  @override
  _ProgressDownloadState createState() => _ProgressDownloadState();
}

class _ProgressDownloadState extends State<ProgressDownload>
    with SingleTickerProviderStateMixin {
  Dio get dio => Dio();
  bool loading = false;
  double progress = 0;

  Future<bool> downloadVideo() async {
    final request = Request('GET', Uri.parse(widget.videoUrl));
    final response = await Client().send(request);
    final contentLength = response.contentLength;

    final file = await getFile('${widget.judul}.mp4');
    final bytes = <int>[];
    response.stream.listen(
      (newBytes) {
        bytes.addAll(newBytes);

        setState(() {
          progress = bytes.length / contentLength!;
        });
      },
      onDone: () async {
        setState(() {
          progress = 1;
        });

        await file.writeAsBytes(bytes);
      },
      onError: print,
      cancelOnError: true,
    );

    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/SmartSchool";
          directory = Directory(newPath);

          print("$directory");
          alertDialog(directory);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/${widget.judul}.mp4");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(widget.videoUrl, saveFile.path,
            onReceiveProgress: (value1, value2) {
          setState(() {
            progress = value1 / value2;
          });
        });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      e.toString();
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<File> getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');

    return file;
  }

  @override
  void initState() {
    downloadVideo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  alertDialog(Directory dir) {
    showDialog(context: context, builder: (_){
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Video yang terdownload tersimpan dalam ", style: TextStyle(fontSize: 12),),
            const SizedBox(height: 4),
            Text("$dir", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),)
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Download'),
          centerTitle: true,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/5,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 160,
                          height: 90,
                          child: ClipRRect(
                            child: CachedNetworkImage(
                                imageUrl: widget.imageUrl, fit: BoxFit.cover),
                          )),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Text(
                              widget.judul,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )),
                            progress != 1
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Downloading - ${(progress * 100).toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CircularProgressIndicator(
                                              value: progress,
                                              color: Colors.blue,
                                              valueColor:
                                                  const AlwaysStoppedAnimation(
                                                      Colors.green),
                                              strokeWidth: 3,
                                              backgroundColor: Colors.black12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'Download Completed',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
