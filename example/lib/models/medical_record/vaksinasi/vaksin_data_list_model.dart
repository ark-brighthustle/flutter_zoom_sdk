class VaksinDataListModel{
  int? id;
  String? dose1_num;
  String? dose2_num;
  String? bstr_num;

  VaksinDataListModel(
      {required this.id,
        required this.dose1_num,
        required this.dose2_num,
        required this.bstr_num});

  factory VaksinDataListModel.fromJson(Map<String, dynamic> json) {
    return VaksinDataListModel(
        id: json['id'],
        dose1_num: json['dose1_num'],
        dose2_num: json['dose2_num'],
        bstr_num: json['bstr_num']);
  }
}