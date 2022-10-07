import 'dart:async';
import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/constant.dart';
import 'play_video_page.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  Directory dir = Directory("/storage/emulated/0/SmartSchool");

  Future<List<FileSystemEntity>> dirContents() {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file), onDone: () => completer.complete(files));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleAppBarDownload, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kWhite),),
      ),
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: FutureBuilder<List<FileSystemEntity>>(
            future: dirContents(),
            builder: _buildDirectory,
          )),
    );
  }

  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/download.png', width: 60,),
          const Text("Belum ada video yang di download", style: TextStyle(fontSize: 12),),
        ],
      );
    }

    return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, i) {
          FileSystemEntity entity = snapshot.data![i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlayVideoPage(
                          judul: FileManager.basename(entity))));
            },
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.play_lesson,
                    size: 36,
                    color: kCelticBlue,
                  ),
                  title: Text(FileManager.basename(entity), style: const TextStyle(fontSize: 12),),
                  subtitle: subtitle(entity),
                ),
                const Divider(thickness: 1,)
              ],
            ),
          );
        });
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              FileManager.formatBytes(size), style: const TextStyle(fontSize: 12),
            );
          }
          return Text(
            "${snapshot.data!.modified}", style: const TextStyle(fontSize: 12),
          );
        } else {
          return const Text("");
        }
      },
    );
  }
}
