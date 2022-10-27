import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/submit_kompetisi/submit_kompetisi_model.dart';
import '../../services/submit_kompetisi/submit_kompetisi_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';

// ignore: must_be_immutable
class DetailBannerNewsEvent extends StatefulWidget {
  final String idSiswa;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  String? juknisUrl;
  DetailBannerNewsEvent(
      {Key? key,
      required this.idSiswa,
      required this.title,
      required this.category,
      required this.description,
      required this.imageUrl,
      required this.juknisUrl})
      : super(key: key);

  @override
  State<DetailBannerNewsEvent> createState() => _DetailBannerNewsEventState();
}

class _DetailBannerNewsEventState extends State<DetailBannerNewsEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDeskripsi = TextEditingController();
  Future<SubmitKompetisiModel>? _futureSubmitKompetisi;

  String imagePath = "";

  void _launchUrlJuknis(Uri _urlJuknis) async {
    if (!await launchUrl(_urlJuknis)) throw 'Could not launch $_urlJuknis';
  }

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imagePath = pickedFile!.path;
    });
  }

  Future<dynamic> submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _futureSubmitKompetisi = submitKompetisi(widget.idSiswa,
            widget.category, _controllerDeskripsi.text, imagePath);
      });

      alertSubmit();
    }
  }

  void alertSubmit() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(Icons.check_circle_outline_rounded,
                color: kGreen, size: 90),
            content: const Text("Data berhasil disubmit"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pushNamed(context, '/navbar');
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    _controllerDeskripsi.dispose();
    super.dispose();
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
                children: [
                  bannerHeader(size),
                  title(),
                  description(),
                  //linkJuknis(),
                  //formSubmit(context),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildIconBack() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kWhite.withOpacity(0.7)),
      child: Center(
        child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
            )),
      ),
    );
  }

  Widget bannerHeader(Size size) {
    return Stack(
      children: [
        SizedBox(
          child: ClipRRect(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),
        ),
        Positioned(left: 16, top: 16, child: buildIconBack())
        ],
      );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Text(
        widget.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget description() {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Text(
        widget.description,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget linkJuknis() {
    return widget.juknisUrl == null
        ? Container()
        : TextButton(
            onPressed: () {
              _launchUrlJuknis(Uri.parse(widget.juknisUrl.toString()));
            },
            child: const Text("Download Juknis"));
  }

  Widget formSubmit(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      margin: const EdgeInsets.all(padding),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Silahkan isi Form di bawah",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _controllerDeskripsi,
                decoration: InputDecoration(
                    labelText: widget.category == "design"
                        ? 'Masukkan Deskripsi'
                        : 'Masukkan Link Google Drive'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lengkapi data ini';
                  }
                  return null;
                },
              ),
              widget.category == "surat"
                  ? imagePath == ""
                      ? TextButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Upload File'))
                      : Column(
                          children: [
                            TextButton.icon(
                                onPressed: pickImage,
                                icon: const Icon(Icons.folder_open),
                                label: const Text('Upload File')),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: padding),
                              child: Text(
                                imagePath,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buttonSubmit(),
                ],
              )
            ],
          )),
    );
  }

  Widget buttonSubmit() {
    return Container(
      margin: const EdgeInsets.all(padding),
      width: 120,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kCelticBlue)),
          onPressed: submitData,
          child: const Center(child: Text('Submit'))),
    );
  }
}
