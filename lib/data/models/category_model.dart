class CategoryModel {
  int? _id;
  String? _name;
  String? _imageMedium;
  String? _start;
  String? _end;

  int get id => _id ?? 0;
  String get name => _name ?? '';
  String? get imageMedium => _imageMedium;
  String? get start => _start;
  String? get end => _end;

  CategoryModel(
      {int? id,
      String? name,
      String? imageMedium,
      String? start,
      String? end}) {
    _id = id;
    _name = name;
    _imageMedium = imageMedium;
    _start = start;
    _end = end;
  }

  CategoryModel.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _imageMedium = json["image_medium"];
    _start = json["start"];
    _end = json["end"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["image_medium"] = _imageMedium;
    map["start"] = _start;
    map["end"] = _end;
    return map;
  }
}
