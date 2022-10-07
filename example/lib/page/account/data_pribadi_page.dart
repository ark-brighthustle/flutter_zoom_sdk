import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/account/profil_model.dart';
import '../../services/account/profil_services.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import 'foto_profil_page.dart';

// ignore: must_be_immutable
class DataPribadiPage extends StatefulWidget {
  final String idSiswa;
  final String nama;
  final String email;
  final String nisn;
  final String kelas;
  final String angkatan;
  const DataPribadiPage(
      {Key? key,
      required this.idSiswa,
      required this.nama,
      required this.email,
      required this.nisn,
      required this.kelas,
      required this.angkatan})
      : super(key: key);

  @override
  State<DataPribadiPage> createState() => _DataPribadiPageState();
}

class _DataPribadiPageState extends State<DataPribadiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerNama = TextEditingController();
  final TextEditingController _controllerNisn = TextEditingController();
  final TextEditingController _controllerKelas = TextEditingController();
  final TextEditingController _controllerAngkatan = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  Future<Profil>? _futureProfil;
  Profil? profil;
  var _imageFile;

  pickImage() async {
    final _pickImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    var filePath = File(_pickImage!.path);
    //var fileName = filePath.path.split('/').last;
    setState(() {
      _imageFile = filePath;
      submitProfil();
      //_futureProfil = updateDataProfil(filePath, idSiswa);
    });
  }

  submitProfil() async {
    if (_imageFile != null) {
      var response = await ProfilServices()
          .updateDataProfil(widget.idSiswa.toString(), _imageFile);

      if (response != null) {
        setState(() {
          profil = response.data;
        });

        if (response.data != null) {
          displaySnackBar('Berhasil Update Profil');
        } else {
          displaySnackBar('Gagal Memuat Data!');
        }
      }
    }
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    _controllerNama.text = widget.nama;
    _controllerNisn.text = widget.nisn;
    _controllerKelas.text = widget.kelas;
    _controllerAngkatan.text = widget.angkatan;
    _controllerEmail.text = widget.email;
    _futureProfil = fetchProfil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [buildHeader(), buildFotoProfil(), buildFormData(), buttonUpdate()],
          ),
        ),
      ),
    ));
  }

  Widget iconBackButton() {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
      color: kBlack,
      iconSize: 20,
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        iconBackButton(),
        const SizedBox(width: 12,),
        const Text(textDataPribadi, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
      ],
    );
  }

  Widget buildFotoProfil() {
    return SizedBox(
      height: 160.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Profil>(
                      future: _futureProfil,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FotoProfilPage(
                                        foto:
                                            "https://e-andalan.id/images/siswa/default.jpg"))),
                            child: const CircleAvatar(
                              backgroundColor: kGrey,
                              backgroundImage: NetworkImage(
                                  "https://e-andalan.id/images/siswa/default.jpg"),
                              radius: 48,
                            ),
                          );
                        }

                        return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FotoProfilPage(
                                        foto: snapshot.data!.foto.toString()))),
                            child: CircleAvatar(
                              backgroundColor: kGrey,
                              backgroundImage:
                                  NetworkImage("${snapshot.data!.foto}"),
                              radius: 48,
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 120,
              left: 190,
              child: GestureDetector(
                onTap: pickImage,
                child: const CircleAvatar(
                    backgroundColor: kGrey,
                    radius: 12,
                    child: Icon(
                      Icons.add_a_photo_rounded,
                      color: kCelticBlue,
                      size: 14,
                    )),
              )),
        ],
      ),
    );
  }

  Widget buildFormData() {
    return Form(
      key: _formKey,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
          child: TextFormField(
            readOnly: true,
            controller: _controllerNama,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              labelText: 'Nama',
              border: OutlineInputBorder()
            ),
          ),
        ),
         Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
          child: TextFormField(
            readOnly: true,
            controller: _controllerEmail,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              labelText: 'Email',
              border: OutlineInputBorder()
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
          child: TextFormField(
            readOnly: true,
            controller: _controllerNisn,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              labelText: 'NISN',
              border: OutlineInputBorder()
            ),
          ),
        ),
         Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
          child: TextFormField(
            readOnly: true,
            controller: _controllerKelas,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              labelText: 'Kelas',
              border: OutlineInputBorder()
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
          child: TextFormField(
            readOnly: true,
            controller: _controllerAngkatan,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              labelText: 'Angkatan',
              border: OutlineInputBorder()
            ),
          ),
        ),
        
      ],));
  }

  Widget buttonUpdate() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: padding),
      child: _imageFile != null
      ? ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(kCelticBlue)),
        onPressed: (){
          setState(() {
            _futureProfil = fetchProfil();
          });
        }, child: const SizedBox(
          height: 48,
          child: Center(child: Text("Update Foto Profil"),),))
          : Container()
    );
  }
}
