class VolumeJson {
  String? kind;
  int? id;
  String? etag;
  String? selfLink;
  VolumeInfo? volumeInfo; 
  AccessInfo? accessInfo;

  VolumeJson({required this.kind, required this.id, required this.etag, required this.selfLink, required this.volumeInfo, required this.accessInfo});

  factory VolumeJson.fromJson(Map<String, dynamic> parsedJson) {
    return VolumeJson(
        kind: parsedJson['kind'],
        id: parsedJson['totalItems'],
        etag: parsedJson['etag'],
        selfLink: parsedJson['selfLink'],
        volumeInfo: VolumeInfo.fromJson(parsedJson['volumeInfo']),
        accessInfo: AccessInfo.fromJson(parsedJson['accessInfo'])
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
  int? pageCount;
  String? publishedDate;

  VolumeInfo({required this.printType, required this.title, required this.publisher, required this.description, required this.image, required this.previewLinks, required this.infoLinks, required this.pageCount, required this.publishedDate});

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
      infoLinks: parsedJson['infoLink'],
      pageCount: parsedJson['pageCount'],
      publishedDate: parsedJson['publishedDate']
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

class AccessInfo {
  final String webReaderLinks;

  AccessInfo({required this.webReaderLinks});

  factory AccessInfo.fromJson(Map<String, dynamic> parsedJson) {
    return AccessInfo(
      webReaderLinks: parsedJson['webReaderLink']);
  }
}