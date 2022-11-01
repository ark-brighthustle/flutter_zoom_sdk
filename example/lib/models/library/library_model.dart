class VolumeJson {
  String? kind;
  int? id;
  String? etag;
  String? selfLink;
  VolumeInfo? volumeInfo; 

  VolumeJson({required this.kind, required this.id, required this.etag, required this.selfLink, required this.volumeInfo});

  factory VolumeJson.fromJson(Map<String, dynamic> parsedJson) {
    return VolumeJson(
        kind: parsedJson['kind'],
        id: parsedJson['totalItems'],
        etag: parsedJson['etag'],
        selfLink: parsedJson['selfLink'],
        volumeInfo: VolumeInfo.fromJson(parsedJson['volumeInfo'])
        );
  }
}

class VolumeInfo {
  String? title;
  String? publisher;
  String? description;
  String? printType;
  ImageLinks? image;
  String? previewLinks;
  String? infoLinks;

  VolumeInfo({required this.printType, required this.title, required this.publisher, required this.description, required this.image, required this.previewLinks, required this.infoLinks});

  factory VolumeInfo.fromJson(Map<String, dynamic> parsedJson) {

    print('GETTING DATA');
    //print(isbnList[1]);
    return VolumeInfo(
      title: parsedJson['title'],
      publisher: parsedJson['publisher'],
      description: parsedJson['description'],
      printType: parsedJson['printType'],
      image: ImageLinks.fromJson(parsedJson['imageLinks'],),
      previewLinks: parsedJson['previewLink'],
      infoLinks: parsedJson['infoLink']
    );
  }
}

class ImageLinks {
  String? thumb;
  
  ImageLinks({required this.thumb});

  factory ImageLinks.fromJson(Map<String, dynamic> parsedJson) {
    return ImageLinks(thumb: parsedJson['thumbnail']);
  }
}

class ISBN {
  final String iSBN13;
  final String type;

  ISBN({required this.iSBN13, required this.type});

  factory ISBN.fromJson(Map<String, dynamic> parsedJson) {
    return ISBN(
      iSBN13: parsedJson['identifier'],
      type: parsedJson['type'],
    );
  }
}