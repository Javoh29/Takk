import 'package:takk/data/models/category_model.dart';

class ProductModel {
  int? _id;
  String? _imageSmall;
  String? _imageMedium;
  String? _imageLarge;
  List<Modifiers>? _modifiers;
  List<Sizes>? _sizes;
  CategoryModel? _category;
  String? _image;
  String? _name;
  String? _description;
  String? _createdDt;
  String? _updatedDt;
  int? _position;
  String? _start;
  String? _end;
  String? _quickestTime;
  int? _taxPercent;
  bool? _available;
  int count = 1;
  String comment = '';
  double totalSum = 0;

  int get id => _id ?? 0;
  String? get imageSmall => _imageSmall;
  String? get imageMedium => _imageMedium;
  String? get imageLarge => _imageLarge;
  List<Modifiers> get modifiers => _modifiers ?? [];
  List<Sizes> get sizes => _sizes ?? [];
  CategoryModel? get category => _category;
  String? get image => _image;
  String? get name => _name;
  String? get description => _description;
  String? get createdDt => _createdDt;
  String? get updatedDt => _updatedDt;
  int? get position => _position;
  String get start => _start ?? '';
  String get end => _end ?? '';
  String? get quickestTime => _quickestTime;
  int? get taxPercent => _taxPercent;
  bool get available => _available ?? false;

  ProductModel(
      {int? id,
        String? imageSmall,
        String? imageMedium,
        String? imageLarge,
        List<Modifiers>? modifiers,
        List<Sizes>? sizes,
        CategoryModel? category,
        String? image,
        String? name,
        String? description,
        String? createdDt,
        String? updatedDt,
        int? position,
        String? start,
        String? end,
        String? quickestTime,
        int? taxPercent,
        bool? available}) {
    _id = id;
    _imageSmall = imageSmall;
    _imageMedium = imageMedium;
    _imageLarge = imageLarge;
    _modifiers = modifiers;
    _sizes = sizes;
    _category = category;
    _image = image;
    _name = name;
    _description = description;
    _createdDt = createdDt;
    _updatedDt = updatedDt;
    _position = position;
    _start = start;
    _end = end;
    _quickestTime = quickestTime;
    _taxPercent = taxPercent;
    _available = available;
  }

  ProductModel.fromJson(dynamic json) {
    _id = json["id"];
    _imageSmall = json["image_small"];
    _imageMedium = json["image_medium"];
    _imageLarge = json["image_large"];
    if (json["modifiers"] != null) {
      _modifiers = [];
      json["modifiers"].forEach((v) {
        _modifiers?.add(Modifiers.fromJson(v));
      });
    }
    if (json["sizes"] != null) {
      _sizes = [];
      json["sizes"].forEach((v) {
        _sizes?.add(Sizes.fromJson(v));
      });
    }
    _category =
    json["category"] != null ? CategoryModel.fromJson(json["category"]) : null;
    _image = json["image"];
    _name = json["name"];
    _description = json["description"];
    _createdDt = json["created_dt"];
    _updatedDt = json["updated_dt"];
    _position = json["position"];
    _start = json["start"];
    _end = json["end"];
    _quickestTime = json["quickest_time"];
    _taxPercent = json["tax_percent"];
    _available = json["available"];
    comment = json["instruction"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["image_small"] = _imageSmall;
    map["image_medium"] = _imageMedium;
    map["image_large"] = _imageLarge;
    if (_modifiers != null) {
      map["modifiers"] = _modifiers?.map((v) => v.toJson()).toList();
    }
    if (_sizes != null) {
      map["sizes"] = _sizes?.map((v) => v.toJson()).toList();
    }
    if (_category != null) {
      map["category"] = _category?.toJson();
    }
    map["image"] = _image;
    map["name"] = _name;
    map["description"] = _description;
    map["created_dt"] = _createdDt;
    map["updated_dt"] = _updatedDt;
    map["position"] = _position;
    map["start"] = _start;
    map["end"] = _end;
    map["quickest_time"] = _quickestTime;
    map["tax_percent"] = _taxPercent;
    map["available"] = _available;
    map["instruction"] = comment;
    return map;
  }
}

class Sizes {
  int? _id;
  String? _name;
  String? _price;
  bool? _available;
  bool? _default;
  int? _product;

  int get id => _id ?? 0;
  String? get name => _name;
  String get price => _price ?? '0';
  bool? get available => _available;
  bool get mDefault => _default ?? false;
  int? get product => _product;

  set mDefault(bool value) => _default = value;

  Sizes(
      {int? id,
        String? name,
        String? price,
        bool? available,
        bool? mDefault,
        int? product}) {
    _id = id;
    _name = name;
    _price = price;
    _available = available;
    _default = mDefault;
    _product = product;
  }

  Sizes.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _price = json["price"];
    _available = json["available"];
    _default = json["default"];
    _product = json["product"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["price"] = _price;
    map["available"] = _available;
    map["default"] = _default;
    map["product"] = _product;
    return map;
  }
}

class Modifiers {
  int? _id;
  List<Items>? _items;
  String? _name;
  bool? _isSingle;
  bool? _required;
  bool? _available;
  int? _position;

  int get id => _id ?? 0;
  List<Items> get items => _items ?? [];
  String? get name => _name;
  bool get isSingle => _isSingle ?? false;
  bool? get required => _required;
  bool? get available => _available;
  int? get position => _position;

  Modifiers(
      {int? id,
        List<Items>? items,
        String? name,
        bool? isSingle,
        bool? required,
        bool? available,
        int? position}) {
    _id = id;
    _items = items;
    _name = name;
    _isSingle = isSingle;
    _required = required;
    _available = available;
    _position = position;
  }

  Modifiers.fromJson(dynamic json) {
    _id = json["id"];
    if (json["items"] != null) {
      _items = [];
      json["items"].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _name = json["name"];
    _isSingle = json["is_single"];
    _required = json["required"];
    _available = json["available"];
    _position = json["position"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    if (_items != null) {
      map["items"] = _items?.map((v) => v.toJson()).toList();
    }
    map["name"] = _name;
    map["is_single"] = _isSingle;
    map["required"] = _required;
    map["available"] = _available;
    map["position"] = _position;
    return map;
  }
}

class Items {
  int? _id;
  String? _name;
  String? _price;
  bool? _available;
  bool? _default;
  int? _position;

  int get id => _id ?? 0;
  String? get name => _name;
  String get price => _price ?? '';
  bool? get available => _available;
  bool get mDefault => _default ?? false;
  int? get position => _position;

  set mDefault(bool value) => _default = value;

  Items(
      {int? id,
        String? name,
        String? price,
        bool? available,
        bool? mDefault,
        int? position}) {
    _id = id;
    _name = name;
    _price = price;
    _available = available;
    _default = mDefault;
    _position = position;
  }

  Items.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _price = json["price"];
    _available = json["available"];
    _default = json["default"];
    _position = json["position"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["price"] = _price;
    map["available"] = _available;
    map["default"] = _default;
    map["position"] = _position;
    return map;
  }
}
