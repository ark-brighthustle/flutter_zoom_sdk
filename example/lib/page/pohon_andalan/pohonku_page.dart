import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/pohon_andalan/pohon_andalan_service.dart';
import '../../theme/colors.dart';
import '../../utils/constant.dart';
import 'pohonku_maps.dart';
import 'pohonku_page_detail.dart';

class PohonkuPage extends StatefulWidget{
  final String idSiswa;

  const PohonkuPage({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<PohonkuPage> createState() => _PohonAndalanStatePage();
}

class _PohonAndalanStatePage extends State<PohonkuPage> {

  final TextEditingController _controllerNamaPohon = TextEditingController();
  final TextEditingController _controllerKeterangan = TextEditingController();

  List PohonAndalanlist = [];

  Future _getPohonAndalanResource() async {
    var response = await PohonAndalanService().getPohonAndalan("760","760");
    if (!mounted) return;
    setState(() {
      PohonAndalanlist = response;
    });
  }

  @override
  void initState() {
    _getPohonAndalanResource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              titlePohonAndalan,
            ),
            Visibility(
              visible: true,
              child: Text(
                "Pohonku",
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
          ],
        ),
      ),
      body: itemList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child:  FloatingActionButton.extended(
            onPressed: () {
              _bottomSheetTambahPohon();
            },
            icon: Image.asset(
              "assets/pohon_andalan/icon_tambah_pohon.png",
              width: 25,
            ),
            label: Text('Tanam Pohon', style: const TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: kCelticBlue
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget itemList(){
     return ListView.builder(
         itemCount: PohonAndalanlist.length,
     itemBuilder: (context, i) {
       return GestureDetector(
         onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => PohonPageDetail(lat: PohonAndalanlist[i].lat, lng: PohonAndalanlist[i].lng, nama: PohonAndalanlist[i].nama, deskripsi: PohonAndalanlist[i].deskripsi, timestamps: PohonAndalanlist[i].timestamps)));
         },
         child: Card(
           child:  Padding(
             padding: const EdgeInsets.all(16.0),
             child: Row(
               children: [
                 SizedBox(
                   width: 75,
                   height: 75,
                   child: ClipRRect(
                       borderRadius: BorderRadius.circular(12),
                       child: Image.network(
                         PohonAndalanlist[i].foto,
                         fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) {
                           return Container(
                               alignment: Alignment.center,
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: const [
                                   Icon(
                                     Icons.broken_image,
                                     size: 90,
                                     color: kGrey,
                                   ),
                                 ],
                               ));
                         },
                       )),
                 ),
                 Padding(padding: const EdgeInsets.only(left: 16.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(PohonAndalanlist[i].nama, style: const TextStyle(fontWeight: FontWeight.w600,),),
                         Text(PohonAndalanlist[i].timestamps, style: TextStyle(color: Colors.black,),)
                       ],
                     )
                 ),
                 Spacer(),
                 Icon(
                   Icons.arrow_forward_ios,
                   size: 16,
                 ),
               ],
             ),
           ),
         ),
       );
     });
  }

  _bottomSheetTambahPohon() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Container(
                              height: 8.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(const Radius.circular(80.0))))
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,left: 23.0,right: 23.0,top: 23.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Text(
                              'Nama Pohon',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Card(
                            elevation: 1.0,
                            margin: EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0,),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.event_note,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _controllerNamaPohon,
                                      autofocus: false,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                                        hintText: "Masukkan nama pohon",
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                      autovalidateMode: AutovalidateMode.always,
                                      autocorrect: false,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              top: 10.0,
                            ),
                            child: Text(
                              'Keterangan',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Card(
                            elevation: 1.0,
                            margin: EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0,),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.event_note,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _controllerKeterangan,
                                      maxLines: 4,
                                      autofocus: false,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                                        hintText: "Masukkan keterangan",
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                      autovalidateMode: AutovalidateMode.always,
                                      autocorrect: false,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              top: 10.0,
                            ),
                            child: Text(
                              'Lokasi Penanaman',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PohonkuMaps())),
                            child: Card(
                              elevation: 1.0,
                              margin: EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0,),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                          onTap: () => {},
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                              ),
                                              text: "Belum memasukkan lokasi penanaman",
                                            ),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              top: 10.0,
                            ),
                            child: Text(
                              'Foto Penanaman',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child:  GestureDetector(
                                onTap: () => {},
                                child: Image.asset("assets/pohon_andalan/upload.png",)),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24))),
                                  ),
                                  onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cooming Soon"))); },
                                  child: const SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: Center(
                                          child: Text(
                                            "Simpan",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ))))
                          )
                        ],
                      ),
                    ),
                  ]),
          );
        });
  }
}