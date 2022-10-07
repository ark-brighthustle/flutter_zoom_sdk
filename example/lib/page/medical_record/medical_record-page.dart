import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/medical_record/vaksinasi/vaksin_data.dart';
import '../../models/medical_record/vaksinasi/vaksin_data_list_model.dart';
import '../../models/medical_record/vaksinasi/vaksin_family_list_model.dart';
import '../../models/medical_record/vaksinasi/vaksin_family_update_model.dart';
import '../../models/medical_record/vaksinasi/vaksin_siswa_list_model.dart';
import '../../services/medical_record/vaksin_service.dart';
import '../../theme/colors.dart';
import '../../utils/constant.dart';
import '../../utils/enum.dart';

class MedicalRecordPage extends StatefulWidget {
  final bool isEdit;
  final int idSiswa;
  final String nik;
  final String jekel;
  final String email;

  const MedicalRecordPage(
      {Key? key,
      required this.idSiswa,
      required this.nik,
      required this.isEdit,
      required this.jekel,
      required this.email})
      : super(key: key);

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _listStatus = ['Ayah', 'Ibu', 'Saudara'];
  String? _selectedStatus;
  JenisKelamin? _jekel;
  String? hubKeluarga;
  String? TglLahir;
  String? TglLahirKeluarga1;

  VaksinData? vaksinData;
  VaksinSiswaListModel? vaksinSiswaListModel;
  VaksinDataListModel? vaksinDataListModel;
  VaksinFamilyListModel? vaksinFamilyListModel;
  VaksinFamilyUpdateModel? vaksinFamilyUpdateModel;

  int _currentReady = 0;
  int _currentStep = 0;
  DateTime _dateTime = DateTime.now();
  StepperType stepperType = StepperType.horizontal;

  //Data diri
  final TextEditingController _controllerNik = TextEditingController();
  final TextEditingController _controllerNoKk = TextEditingController();
  final TextEditingController _controllerJekel = TextEditingController();
  final TextEditingController _controllerTempatLahir = TextEditingController();
  final TextEditingController _controllerTglLahir = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerAlamat = TextEditingController();
  final TextEditingController _controllerNoHp = TextEditingController();

  //Data vaksinasi
  final TextEditingController _controllerIdSertifikatVaksin =
      TextEditingController();
  final TextEditingController _controllerNoVaksin1 = TextEditingController();
  final TextEditingController _controllerNoVaksin2 = TextEditingController();
  final TextEditingController _controllerNoBooster = TextEditingController();

  //Data keluarga
  final TextEditingController _controllerNamaKeluarga1 =
      TextEditingController();
  final TextEditingController _controllerNikKeluarga1 = TextEditingController();
  final TextEditingController _controllerTglLahirKeluarga1 =
      TextEditingController();
  final TextEditingController _controllerNoVaksin1Keluarga1 =
      TextEditingController();
  final TextEditingController _controllerNoVaksin2Keluarga1 =
      TextEditingController();
  final TextEditingController _controllerNoBoosterKeluarga1 =
      TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    final DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: today);
    if (_datePicker != null) {
      _dateTime = _datePicker;
      TglLahir = DateFormat('yyyy-MM-dd').format(_dateTime);
      _controllerTglLahir.text = DateFormat('dd/MM/yyyy').format(_dateTime);
    }
  }

  Future<void> selectDateFamily1(BuildContext context) async {
    DateTime today = DateTime.now();
    final DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1950),
        lastDate: today);
    if (_datePicker != null) {
      _dateTime = _datePicker;
      TglLahirKeluarga1 = DateFormat('yyyy-MM-dd').format(_dateTime);
      _controllerTglLahirKeluarga1.text =
          DateFormat('dd/MM/yyyy').format(_dateTime);
    }
  }

  _getDataVaksin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getInt("vaksin_id_siswa") == null) {
      var response = await VaksinService().getDataVaksin(widget.idSiswa);

      if(response != null){
        setState((){
          vaksinData = response.data;
        });

        if(vaksinData!.id_siswa != null){
          await preferences.setInt("vaksin_id_siswa", vaksinData!.id_siswa);
        }
        if(vaksinData!.tempat_lahir != null){
          await preferences.setString("vaksin_tempat_lahir", vaksinData!.tempat_lahir.toString());
          _controllerTempatLahir.text = vaksinData!.tempat_lahir.toString();
        }
        if(vaksinData!.tanggal_lahir != null){
          TglLahir = vaksinData!.tanggal_lahir;
          await preferences.setString("vaksin_tanggal_lahir", vaksinData!.tanggal_lahir.toString());
          DateTime tanggal = DateTime.parse(vaksinData!.tanggal_lahir.toString());
          String tanggal_lahir = DateFormat('dd/MM/yyyy').format(tanggal);
          _controllerTglLahir.text = tanggal_lahir;
        }
        if(vaksinData!.no_kk != null){
          await preferences.setString("vaksin_no_kk", vaksinData!.no_kk.toString());
          _controllerNoKk.text = vaksinData!.no_kk.toString();
        }
        if(vaksinData!.alamat != null){
          await preferences.setString("vaksin_alamat", vaksinData!.alamat.toString());
          _controllerAlamat.text = vaksinData!.alamat.toString();
        }
        if(vaksinData!.hp != null){
          await preferences.setString("vaksin_no_hp", vaksinData!.hp.toString());
          _controllerNoHp.text = vaksinData!.hp.toString();
        }
        if(vaksinData!.no_vaksin1 != null) {
          await preferences.setString("vaksin_no_vaksin1", vaksinData!.no_vaksin1.toString());
          _controllerNoVaksin1.text = vaksinData!.no_vaksin1.toString();
        }
        if(vaksinData!.no_vaksin2 != null) {
          await preferences.setString("vaksin_no_vaksin2", vaksinData!.no_vaksin2.toString());
          _controllerNoVaksin2.text = vaksinData!.no_vaksin2.toString();
        }
        if(vaksinData!.no_booster != null) {
          await preferences.setString("vaksin_no_booster", vaksinData!.no_booster.toString());
          _controllerNoBooster.text = vaksinData!.no_booster.toString();
        }
        await preferences.commit();
        setState((){
          _currentReady = 1;
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }

    }else{
      String? tempatlahir = preferences.getString("vaksin_tempat_lahir");
      String? tanggallahir = preferences.getString("vaksin_tanggal_lahir");
      String? nokk = preferences.getString("vaksin_no_kk");
      String? alamat = preferences.getString("vaksin_alamat");
      String? hp = preferences.getString("vaksin_no_hp");
      String? vaksin1 = preferences.getString("vaksin_no_vaksin1");
      String? vaksin2 = preferences.getString("vaksin_no_vaksin2");
      String? booster = preferences.getString("vaksin_no_booster");
      if(tempatlahir != null) {
        _controllerTempatLahir.text = tempatlahir.toString();
      }
      if(tanggallahir != null){
        TglLahir = tanggallahir;
        DateTime tanggal = DateTime.parse(tanggallahir.toString());
        String tanggal_lahir = DateFormat('dd/MM/yyyy').format(tanggal);
        _controllerTglLahir.text = tanggal_lahir;
      }
      if(nokk != null) {
        _controllerNoKk.text = nokk.toString();
      }
      if(alamat != null){
        _controllerAlamat.text = alamat.toString();
      }
      if(hp != null){
        _controllerNoHp.text = hp.toString();
      }
      if(vaksin1 != null){
        _controllerNoVaksin1.text = vaksin1.toString();
      }
      if(vaksin2 != null){
        _controllerNoVaksin2.text = vaksin2.toString();
      }
      if(booster != null) {
        _controllerNoBooster.text = booster.toString();
      }
      setState((){
        _currentReady = 1;
      });
    }
  }

  _SubmitdataSiswa() async{
    var response = await VaksinService().updateVaksinSiswa(widget.idSiswa,
        _controllerNoKk.text,
        _controllerTempatLahir.text,
        TglLahir.toString(),
        widget.email,
        _controllerAlamat.text,
        _controllerNoHp.text);

    if(response != null){
      setState((){
        vaksinSiswaListModel = response.data;
      });

      if(response.data != null){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if(vaksinSiswaListModel!.tempat_lahir != null){
          await preferences.setString("vaksin_tempat_lahir", vaksinSiswaListModel!.tempat_lahir.toString());
        }
        if(vaksinSiswaListModel!.tanggal_lahir != null){
          await preferences.setString("vaksin_tanggal_lahir", vaksinSiswaListModel!.tanggal_lahir.toString());
        }
        if(vaksinSiswaListModel!.no_kk != null){
          await preferences.setString("vaksin_no_kk", vaksinSiswaListModel!.no_kk.toString());
        }
        if(vaksinSiswaListModel!.alamat != null){
          await preferences.setString("vaksin_alamat", vaksinSiswaListModel!.alamat.toString());
        }
        if(vaksinSiswaListModel!.no_hp != null){
          await preferences.setString("vaksin_no_hp", vaksinSiswaListModel!.no_hp.toString());
        }
        await preferences.commit();
        _currentStep < 2 ? setState(() => _currentStep += 1) : null;
        Navigator.pop(context);
        alertDialogSubmit("Diri Anda");
      }else{
        cancel();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }

    }else{
      cancel();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
    }
  }

  _SubmitdataVaksin() async{
    var response = await VaksinService().updateVaksin(widget.idSiswa,
        _controllerNoVaksin1.text,
        _controllerNoVaksin2.text,
        _controllerNoBooster.text);

    if(response != null){
      setState((){
        vaksinDataListModel = response.data;
      });

      if(response.data != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if(vaksinDataListModel!.dose1_num != null){
          await preferences.setString("vaksin_no_vaksin1", vaksinDataListModel!.dose1_num.toString());
        }
        if(vaksinDataListModel!.dose2_num != null){
          await preferences.setString("vaksin_no_vaksin2", vaksinDataListModel!.dose2_num.toString());
        }
        if(vaksinDataListModel!.bstr_num != null){
          await preferences.setString("vaksin_no_booster", vaksinDataListModel!.bstr_num.toString());
        }
        await preferences.commit();
        _currentStep < 2 ? setState(() => _currentStep += 1) : null;
        Navigator.pop(context);
        alertDialogSubmit("Vaksinasi Anda");
      }else{
        cancel();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }

    }else{
      cancel();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
    }
  }

  _getDataKeluarga(String dataSelect) async{
    showAlertDialogLoading(context);
    var response = await VaksinService().getDatakeluarga(widget.idSiswa,dataSelect);

    if(response != null){
      setState((){
        vaksinFamilyListModel = response.data;
      });

      if(response.data != null){
        if(vaksinFamilyListModel!.nama != null) {
          _controllerNamaKeluarga1.text =
              vaksinFamilyListModel!.nama.toString();
        }else{
          _controllerNamaKeluarga1.clear();
        }
        if(vaksinFamilyListModel!.jenis_kelamin != null){
          if(vaksinFamilyListModel!.jenis_kelamin == "Laki-laki"){
            _jekel = JenisKelamin.lakilaki;
          }else if(vaksinFamilyListModel!.jenis_kelamin == "Perempuan"){
            _jekel = JenisKelamin.perempuan;
          }
        }else{
          _jekel = null;
        }
        if(vaksinFamilyListModel!.nik != null) {
          _controllerNikKeluarga1.text = vaksinFamilyListModel!.nik.toString();
        }else{
          _controllerNikKeluarga1.clear();
        }
        if(vaksinFamilyListModel!.tanggal_lahir != null){
          TglLahirKeluarga1 = vaksinFamilyListModel!.tanggal_lahir.toString();
          DateTime tanggal = DateTime.parse(vaksinFamilyListModel!.tanggal_lahir.toString());
          String tanggal_lahir = DateFormat('dd/MM/yyyy').format(tanggal);
          _controllerTglLahirKeluarga1.text = tanggal_lahir;
        }else{
          _controllerTglLahirKeluarga1.clear();
        }
        if(vaksinFamilyListModel!.dose1_num != null){
          _controllerNoVaksin1Keluarga1.text = vaksinFamilyListModel!.dose1_num.toString();
        }else{
          _controllerNoVaksin1Keluarga1.clear();
        }
        if(vaksinFamilyListModel!.dose2_num != null) {
          _controllerNoVaksin2Keluarga1.text =
              vaksinFamilyListModel!.dose2_num.toString();
        }else{
          _controllerNoVaksin2Keluarga1.clear();
        }
        if(vaksinFamilyListModel!.bstr_num != null) {
          _controllerNoBoosterKeluarga1.text =
              vaksinFamilyListModel!.bstr_num.toString();
        }else{
          _controllerNoBoosterKeluarga1.clear();
        }
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }

    }else{
      _controllerNamaKeluarga1.clear();
      _jekel = null;
      _controllerNikKeluarga1.clear();
      _controllerTglLahirKeluarga1.clear();
      _controllerNoVaksin1Keluarga1.clear();
      _controllerNoVaksin2Keluarga1.clear();
      _controllerNoBoosterKeluarga1.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
    }
  }

  _SubmitdataKeluarga() async{
    if(hubKeluarga == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Anda belum memilih hubungan keluarga")));
      Navigator.pop(context);
    }else if(_jekel == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Anda belum memilih jenis kelamin")));
      Navigator.pop(context);
    }else{
      int jenisKelamin = 0;
      if(_jekel == JenisKelamin.lakilaki){
        jenisKelamin = 1;
      }else if(_jekel == JenisKelamin.perempuan){
        jenisKelamin = 2;
      }
      var response = await VaksinService().updateDatakeluarga(widget.idSiswa,
          hubKeluarga!,
          _controllerNamaKeluarga1.text,
          jenisKelamin,
          _controllerNikKeluarga1.text,
          TglLahirKeluarga1.toString(),
          _controllerNoVaksin1Keluarga1.text,
          _controllerNoVaksin2Keluarga1.text,
          _controllerNoBoosterKeluarga1.text);

      if(response != null){
        setState((){
          vaksinFamilyUpdateModel = response.data;
        });

        if(response.data != null) {
          Navigator.pop(context);
          alertDialogSubmit("Vaksinasi Keluarga Anda");
        }else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
        }

      }else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
      }
    }
  }


  submitDataVaksin(int _currentStep) {
    showAlertDialogLoading(context);
    setState(() {
      if(_currentStep == 0){
        _SubmitdataSiswa();
      }else if(_currentStep == 1) {
        _SubmitdataVaksin();
      }else if(_currentStep == 2) {
        _SubmitdataKeluarga();
      }
    });
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  showAlertDialogLoading(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 15),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  continued() {
    // if (_formKey.currentState!.validate()) {
    submitDataVaksin(_currentStep);
    // }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  alertDialogSubmit(String data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(
              Icons.check_circle_rounded,
              color: kGreen,
              size: 36,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text("Data "+data+" Berhasil Terupdate")],
            ),
          );
        });
  }

  @override
  void initState() {
    if (widget.isEdit) {
      setState(() {
        _controllerJekel.text = widget.jekel;
        _controllerNik.text = widget.nik;
        _controllerEmail.text = widget.email;
        _getDataVaksin();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(titleMedicalRecord)),
        body: SafeArea(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _currentReady == 0
                    ? Center(
                    child: CircularProgressIndicator()
                )
                    : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      backgroundVaksinasi(),
                      Expanded(
                        child: stepsForm(),
                      ),
                    ],
                  ),
                ),
            )));
  }

  Widget backgroundVaksinasi() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset("assets/medical_record/vaksinasi.png"),
    );
  }

  Widget stepsForm() {
    return Stepper(
      type: stepperType,
      physics: const ScrollPhysics(),
      currentStep: _currentStep,
      onStepTapped: (step) => tapped(step),
      onStepContinue: continued,
      onStepCancel: cancel,
      steps: <Step>[
        Step(
          title: const Text(''),
          content: Column(
            children: <Widget>[
              const Text(
                "Data Diri",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _controllerJekel,
                keyboardType: TextInputType.none,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerTempatLahir,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Tempat Lahir',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerTglLahir,
                keyboardType: TextInputType.none,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  labelText: 'Tanggal Lahir',
                ),
                readOnly: true,
                onTap: () => selectDate(context),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.none,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _controllerNik,
                keyboardType: TextInputType.none,
                maxLength: 16,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'NIK',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  } else if (value.length < 16) {
                    return "NIK Anda Salah";
                  }else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerNoKk,
                keyboardType: TextInputType.number,
                maxLength: 16,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nomor Kartu Keluarga',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  } else if (value.length < 16) {
                    return "No.KK Anda Salah";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerAlamat,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerNoHp,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'No.HP',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              /*Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: buttonSubmit(),
                      )*/
            ],
          ),
          isActive: _currentStep >= 0,
          state: _currentStep >= 0
              ? StepState.complete
              : StepState.disabled,
        ),
        Step(
          title: const Text(''),
          content: Column(
            children: <Widget>[
              const Text(
                "Data Vaksinasi Anda",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // TextFormField(
              //   controller: _controllerIdSertifikatVaksin,
              //   maxLength: 24,
              //   textInputAction: TextInputAction.next,
              //   decoration: const InputDecoration(
              //     labelText: 'ID Sertifikat Vaksinasi',
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return "Lengkapi data ini";
              //     } else if (value.length < 24) {
              //       return "ID Sertifikat Vaksinasi Salah";
              //     }
              //
              //     return null;
              //   },
              // ),
              TextFormField(
                controller: _controllerNoVaksin1,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'BATCH ID Vaksin 1',
                ),
              ),
              TextFormField(
                controller: _controllerNoVaksin2,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'BATCH ID Vaksin 2',
                ),
              ),
              TextFormField(
                controller: _controllerNoBooster,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'BATCH ID Booster',
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 0,
          state: _currentStep >= 1
              ? StepState.complete
              : StepState.disabled,
        ),
        Step(
          title: const Text(''),
          content: Column(
            children: <Widget>[
              const Text(
                "Data Vaksinasi Keluarga Anda",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                  items: _listStatus
                      .map((value) => DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  ))
                      .toList(),
                  onChanged: (String? selected) {
                    setState(() {
                      _selectedStatus = selected;
                      hubKeluarga = selected;
                      _getDataKeluarga(_selectedStatus.toString());
                    });
                  },
                  value: _selectedStatus,
                  isExpanded: true,
                  hint: const Text("Hubungan Keluarga")),
              TextFormField(
                controller: _controllerNamaKeluarga1,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      "Jenis Kelamin",
                      style: TextStyle(color: kBlack),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                      activeColor: kCelticBlue,
                      value: JenisKelamin.lakilaki,
                      groupValue: _jekel,
                      onChanged: (JenisKelamin? value) {
                        setState(() {
                          _jekel = value;
                        });
                      }),
                  const Text("Laki-laki"),
                  const SizedBox(
                    width: 24,
                  ),
                  Radio(
                      activeColor: kCelticBlue,
                      value: JenisKelamin.perempuan,
                      groupValue: _jekel,
                      onChanged: (JenisKelamin? value) {
                        setState(() {
                          _jekel = value;
                        });
                      }),
                  const Text("Perempuan"),
                ],
              ),
              TextFormField(
                controller: _controllerNikKeluarga1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                maxLength: 16,
                decoration: const InputDecoration(labelText: 'NIK'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerTglLahirKeluarga1,
                keyboardType: TextInputType.none,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  labelText: 'Tanggal Lahir',
                ),
                readOnly: true,
                onTap: () => selectDateFamily1(context),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              TextFormField(
                controller: _controllerNoVaksin1Keluarga1,
                textInputAction: TextInputAction.done,
                decoration:
                InputDecoration(labelText: "Batch ID Vaksin 1 (Jika ada)"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerNoVaksin2Keluarga1,
                textInputAction: TextInputAction.done,
                decoration:
                InputDecoration(labelText: "Batch ID Vaksin 2 (Jika ada)"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else{
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _controllerNoBoosterKeluarga1,
                textInputAction: TextInputAction.done,
                decoration:
                InputDecoration(labelText: "Batch ID Booster (Jika ada)"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi data ini";
                  }else {
                    return null;
                  }
                },
              )
            ],
          ),
          isActive: _currentStep >= 0,
          state: _currentStep >= 2
              ? StepState.complete
              : StepState.disabled,
        ),
      ],
    );
  }

  /*Widget buttonSubmit() {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24))),
            backgroundColor: MaterialStateProperty.all(kGreen)),
        onPressed: submitDataVaksin,
        child: const SizedBox(
            width: double.infinity,
            height: 48,
            child: Center(
                child: Text(
              "Submit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ))));
  }*/
}