class AmaliahReference{
  int? id;
  String? title;
  String? reference_url;
  String? description;
  String? created_at;

  AmaliahReference({
    required this.id,
    required this.title,
    required this.reference_url,
    required this.description,
    required this.created_at,
  });

  factory AmaliahReference.fromJson(Map<String?, dynamic> json) {
    return AmaliahReference(
        id: json['id'],
        title: json['title'],
        reference_url: json['reference_url'],
        description: json['description'],
        created_at: json['created_at']);
  }
}