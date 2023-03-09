import 'package:flutter/material.dart';

import '../../../../services/classroom/elearning_service.dart';
import '../../../../theme/colors.dart';
import 'detail_bahan_elearning_page.dart';

class BahanElearningPage extends StatefulWidget {
  final int id;
  final String namaKategori;
  const BahanElearningPage({Key? key, required this.id, required this.namaKategori}) : super(key: key);

  @override
  State<BahanElearningPage> createState() => _BahanElearningPageState();
}

class _BahanElearningPageState extends State<BahanElearningPage> {
  List _listBahanElearning = [];

  Future getBahanElearning() async {
    var response = await ElearningService().getDataElearningBahan();
    if (!mounted) return;
    setState(() {
      _listBahanElearning = response;
    });
  }

  @override
  void initState() {
    getBahanElearning();
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
        child: listBahanElearning(),
      ),
    );
  }

  Widget listBahanElearning() {
    return ListView.builder(
      itemCount: _listBahanElearning.length,
      itemBuilder: (context, i){
        return Column(
          children: [
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBahanElearningPage(
                id: _listBahanElearning[i].id,
                elearningCategoryId: _listBahanElearning[i].elearningCategoryId,
                namaKategori: _listBahanElearning[i].namaKategori,
                idMataPelajaran: _listBahanElearning[i].idMataPelajaran,
                namaMataPelajaran: _listBahanElearning[i].namaMataPelajaran,
                judul: _listBahanElearning[i].judul,
                deskripsi: _listBahanElearning[i].deskripsi,
                fileUrl: _listBahanElearning[i].fileUrl,
                videoUrl: _listBahanElearning[i].videoUrl,
                waktuMulai: _listBahanElearning[i].waktuMulai,
                waktuSelesai: _listBahanElearning[i].waktuSelesai,
                createdAt: _listBahanElearning[i].createdAt,
                updatedAt: _listBahanElearning[i].updatedAt 
              ))),
              title: Text("${_listBahanElearning[i].namaMataPelajaran}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
              subtitle: Text("${_listBahanElearning[i].judul}", style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
            ),
            const Divider(thickness: 1,)
          ],
        );
    });
  }
}