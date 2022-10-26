import 'package:takk/data/models/emp_order_model.dart';

import 'cafe_model/location.dart';

class CartResponse {
  late int _id;
  late List<CartModel> _items;
  late double _subTotalPrice;
  DeliveryInfo? _deliveryInfo;
  String? _taxTotal;
  String? _deliveryPrice;
  String? _tax;
  String? _freeItems;
  String? _totalPrice;
  String? _tip;
  int? _tipPercent;
  Cafe? _cafe;
  int? _preOrderTimestamp;
  String? _name;
  String? _status;
  String? _cashback;
  bool? _like;

  int get id => _id;

  List<CartModel> get items => _items;

  double get subTotalPrice => _subTotalPrice;

  set subTotalPrice(double value) => _subTotalPrice = value;

  String get taxTotal => _taxTotal ?? '0';

  String get deliveryPrice => _deliveryPrice ?? '0';

  DeliveryInfo? get delivery => _deliveryInfo;

  String get tax => _tax ?? '0';

  String get freeItems => _freeItems ?? '0';

  String get totalPrice => _totalPrice ?? '0';

  String get tip => _tip ?? '0';

  int get tipPercent => _tipPercent ?? 0;

  Cafe? get cafe => _cafe;

  int? get preOrderTimestamp => _preOrderTimestamp;

  String? get name => _name;

  String? get status => _status;

  String? get cashback => _cashback;

  bool? get like => _like;

  setLike(bool value) {
    _like = value;
  }

  CartResponse(
      {required int id,
      required List<CartModel> items,
      required double subTotalPrice,
      String? taxTotal,
      String? deliveryPrice,
      DeliveryInfo? deliveryInfo,
      String? tax,
      String? freeItems,
      String? totalPrice,
      String? tip,
      int? tipPercent,
      Cafe? cafe,
      int? preOrderTimestamp,
      String? name,
      String? status,
      String? cashback,
      bool? like,
      CafeItem? cafeInfo}) {
    _id = id;
    _items = items;
    _subTotalPrice = subTotalPrice;
    _taxTotal = taxTotal;
    _deliveryPrice = deliveryPrice;
    _deliveryInfo = deliveryInfo;
    _tax = tax;
    _freeItems = freeItems;
    _totalPrice = totalPrice;
    _tip = tip;
    _tipPercent = tipPercent;
    _cafe = cafe;
    _preOrderTimestamp = preOrderTimestamp;
    _name = name;
    _status = status;
    _like = like;
    _cashback = cashback;
  }

  CartResponse.fromJson(dynamic json, {bool isFav = false}) {
    _id = json["id"];
    if (json["items"] != null) {
      _items = [];
      json["items"].forEach((v) {
        _items.add(CartModel.fromJson(v, isFav));
      });
    }
    _subTotalPrice = double.parse(json["sub_total_price"]);
    _taxTotal = json['tax_total'];
    _deliveryPrice = json['delivery_price'];
    _deliveryInfo = json['delivery'] != null
        ? DeliveryInfo.fromJson(json['delivery'])
        : DeliveryInfo(id: 0, instruction: '');
    _tax = json['tax'];
    _freeItems = json['free_items'];
    _totalPrice = json['total_price'];
    _tip = json['tip'];
    _tipPercent = json['tip_percent'];
    _preOrderTimestamp = json['pre_order_timestamp'];
    _cafe = Cafe.fromJson(json["cafe"]);
    _name = json['name'];
    _cashback = json['cashback'];
    _status = json['status'];
    _like = json['like'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["items"] = _items.map((v) => v.toJson()).toList();
    map["sub_total_price"] = _subTotalPrice;
    map['tax_total'] = _taxTotal;
    map['tax'] = _tax;
    map['free_items'] = _freeItems;
    map['total_price'] = _totalPrice;
    map['tip'] = _tip;
    map['tip_percent'] = _tipPercent;
    map['pre_order_timestamp'] = _preOrderTimestamp;
    map["cafe"] = _cafe;
    map["name"] = _name;
    map["cashback"] = _cashback;
    map["status"] = _status;
    map["like"] = _like;
    return map;
  }
}

class DeliveryInfo {
  int? id;
  String? address;
  String? latitude;
  String? longitude;
  String instruction = '';

  DeliveryInfo(
      {this.id,
      this.address,
      this.latitude,
      this.longitude,
      this.instruction = ''});

  DeliveryInfo.fromJson(dynamic json) {
    id = json['id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    instruction = json['instruction'] ?? '';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['address'] = address;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}

class CafeItem {
  late int id;
  late String name;
  late String logoSmall;
  Location? loaction;
  String? address;

  CafeItem(
      {required this.id,
      required this.name,
      required this.logoSmall,
      this.loaction,
      this.address});

  CafeItem.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    logoSmall = json['logo_small'];
    loaction = Location.fromJson(json['location']);
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['logo_small'] = logoSmall;
    map['location'] = loaction!.toJson();
    map['address'] = address;
    return map;
  }
}

class CartModel {
  late int _id;
  late String _productPrice;
  String? _modifiersPrice;
  late String _totalPrice;
  late String? _subTotalPrice;
  String? _instruction;
  late String _productName;
  int? _favoriteCart;
  late int _quantity;
  late int _product;
  late int _productSize;
  List<ProductModifiers>? _productModifiers;
  List<ProductModifiers>? favModifiers = [];

  int get id => _id;

  String get productPrice => _productPrice;

  String get modifiersPrice => _modifiersPrice ?? '0.0';

  String get totalPrice => _totalPrice;

  String? get subTotalPrice => _subTotalPrice;

  String get instruction => _instruction ?? '';

  String get productName => _productName;

  int? get favoriteCart => _favoriteCart;

  int get quantity => _quantity;

  int get product => _product;

  int get productSize => _productSize;

  List<ProductModifiers> get productModifiers => _productModifiers ?? [];

  CartModel(
      {required int id,
      required String productPrice,
      required String modifiersPrice,
      required String totalPrice,
      required String subTotalPrice,
      required String instruction,
      required String productName,
      int? favoriteCart,
      required int quantity,
      required int product,
      required int productSize,
      required List<ProductModifiers> productModifiers}) {
    _id = id;
    _productPrice = productPrice;
    _modifiersPrice = modifiersPrice;
    _totalPrice = totalPrice;
    _subTotalPrice = subTotalPrice;
    _instruction = instruction;
    _productName = productName;
    _favoriteCart = favoriteCart;
    _quantity = quantity;
    _product = product;
    _productSize = productSize;
    _productModifiers = productModifiers;
  }

  CartModel.fromJson(dynamic json, bool isFav) {
    _id = json["id"];
    _productPrice = json["product_price"];
    _modifiersPrice = json["modifiers_price"];
    _totalPrice = json["total_price"];
    _subTotalPrice = json["sub_total_price"];
    _instruction = json["instruction"];
    _productName = json["product_name"];
    _favoriteCart = json["favorite_cart"];
    _quantity = json["quantity"];
    _product = json["product"];
    _productSize = json["product_size"];
    if (isFav) {
      favModifiers = (json['product_modifiers'] as List<dynamic>?)
          ?.map((e) => ProductModifiers.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _productModifiers = (json['product_modifiers'] as List<dynamic>?)
          ?.map((e) => ProductModifiers.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["product_price"] = _productPrice;
    map["modifiers_price"] = _modifiersPrice;
    map["total_price"] = _totalPrice;
    map["sub_total_price"] = _subTotalPrice;
    map["instruction"] = _instruction;
    map["product_name"] = _productName;
    map["favorite_cart"] = _favoriteCart;
    map["quantity"] = _quantity;
    map["product"] = _product;
    map["product_size"] = _productSize;
    map["product_modifiers"] = _productModifiers;
    return map;
  }
}

class Cafe {
  int? id;
  String? name;
  String? logoSmall;
  Location? location;
  String? address;
  dynamic secondAddress;
  bool? deliveryAvailable;
  int? deliveryMaxDistance;
  String? deliveryMinAmount;
  String? deliveryFee;
  String? deliveryPercent;
  String? deliveryKmAmount;
  int? deliveryMinTime;

  Cafe({
    this.id,
    this.name,
    this.logoSmall,
    this.location,
    this.address,
    this.secondAddress,
    this.deliveryAvailable,
    this.deliveryMaxDistance,
    this.deliveryMinAmount,
    this.deliveryFee,
    this.deliveryPercent,
    this.deliveryKmAmount,
    this.deliveryMinTime,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) => Cafe(
        id: json['id'] as int?,
        name: json['name'] as String?,
        logoSmall: json['logo_small'] as String?,
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        address: json['address'] as String?,
        secondAddress: json['second_address'] as dynamic,
        deliveryAvailable: json['delivery_available'] as bool?,
        deliveryMaxDistance: json['delivery_max_distance'] as int?,
        deliveryMinAmount: json['delivery_min_amount'] as String?,
        deliveryFee: json['delivery_fee'] as String?,
        deliveryPercent: json['delivery_percent'] as String?,
        deliveryKmAmount: json['delivery_km_amount'] as String?,
        deliveryMinTime: json['delivery_min_time'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo_small': logoSmall,
        'location': location?.toJson(),
        'address': address,
        'second_address': secondAddress,
        'delivery_available': deliveryAvailable,
        'delivery_max_distance': deliveryMaxDistance,
        'delivery_min_amount': deliveryMinAmount,
        'delivery_fee': deliveryFee,
        'delivery_percent': deliveryPercent,
        'delivery_km_amount': deliveryKmAmount,
        'delivery_min_time': deliveryMinTime,
      };
}
