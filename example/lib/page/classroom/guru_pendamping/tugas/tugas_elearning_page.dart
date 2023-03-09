import 'package:flutter/material.dart';

import '../../../../services/classroom/elearning_service.dart';
import '../../../../theme/colors.dart';
import 'detail_tugas_elearning_page.dart';

class TugasElearningPage extends StatefulWidget {
  final int id;
  final String namaKategori;
  const TugasElearningPage(
      {Key? key, required this.id, required this.namaKategori})
      : super(key: key);

  @override
  State<TugasElearningPage> createState() => _TugasElearningPageState();
}

class _TugasElearningPageState extends State<TugasElearningPage> {
  final DateTime _dateTimeNow = DateTime.now();
  List _listTugasElearning = [];

  Future getTugasElearning() async {
    var response = await ElearningService().getDataElearningTugas();
    if (!mounted) return;
    setState(() {
      _listTugasElearning = response;
    });
  }

  @override
  void initState() {
    getTugasElearning();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: kWhite, size: 20,)),
        title: Text(widget.namaKategori, style: const TextStyle(fontSize: 16),),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: listTugasElearning(),
      ),
    );
  }

  Widget listTugasElearning() {
    return ListView.builder(
        itemCount: _listTugasElearning.length,
        itemBuilder: (context, i) {
          return Column(
            children: [
              ListTile(
                onTap: () {
                  if (_dateTimeNow.isBefore(DateTime.parse(_listTugasElearning[i].waktuMulai))) {
                    alertDialogisBefore(_listTugasElearning[i].waktuMulai);
                  } else if (_dateTimeNow.isAfter(DateTime.parse(_listTugasElearning[i].waktuSelesai))) {
                    alertDialogisAfter(_listTugasElearning[i].waktuSelesai);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailTugasElearningPage(
                                id: _listTugasElearning[i].id,
                                elearningCategoryId: _listTugasElearning[i].elearningCategoryId,
                                namaKategori: _listTugasElearning[i].namaKategori,
                                idMataPelajaran: _listTugasElearning[i].idMataPelajaran,
                                namaMataPelajaran:_listTugasElearning[i].namaMataPelajaran,
                                judul: _listTugasElearning[i].judul,
                                deskripsi: _listTugasElearning[i].deskripsi,
                                fileUrl: _listTugasElearning[i].fileUrl,
                                videoUrl: _listTugasElearning[i].videoUrl,
                                waktuMulai: _listTugasElearning[i].waktuMulai,
                                waktuSelesai: _listTugasElearning[i].waktuSelesai,
                                createdAt: _listTugasElearning[i].createdAt,
                                updatedAt: _listTugasElearning[i].updatedAt)));
                  }
                },
                title: Text("${_listTugasElearning[i].namaMataPelajaran}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                subtitle: Text("${_listTugasElearning[i].deskripsi}", style: const TextStyle(fontSize: 12),),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              const Divider(thickness: 1,)
            ],
          );
        });
  }

  alertDialogisBefore(waktuMulai) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.dangerous, size: 72, color: Colors.red),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Etss, Kirim Tugasnya belum dimulai',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                const SizedBox(height: 12,),
                const Text(
                    'Waktu Mulai/Pengerjaan Tugas',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4,),
                Text(
                    '$waktuMulai',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Center(child: Text('OK')))
            ],
          );
        });
  }

  alertDialogisAfter(waktuSelesai) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.dangerous, size: 72, color: Colors.red),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Maaf yaa, Kirim tugasnya telah berakhir!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                const SizedBox(height: 12,),
                const Text(
                    'Batas Waktu Tugas',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    '$waktuSelesai',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Center(child: Text('OK')))
            ],
          );
        });
  }
}
