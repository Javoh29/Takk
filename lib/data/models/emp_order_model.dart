import 'package:takk/data/models/order_model.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/models/cart_response.dart';

class EmpOrderModel {
  int? id;
  List<Items>? main;
  List<Items>? kitchen;
  dynamic delivery;
  CafeModel? cafe;
  User? user;
  String? subTotalPrice;
  String? taxTotal;
  String? totalPrice;
  dynamic freeItems;
  String? status;
  int? preOrderTimestamp;
  String? tip;
  int? tipPercent;
  int? created;
  bool? isKitchen;
  bool? isAcknowledge;
  String? refundAmount;

  EmpOrderModel({
    this.id,
    this.main,
    this.kitchen,
    this.delivery,
    this.cafe,
    this.user,
    this.subTotalPrice,
    this.taxTotal,
    this.totalPrice,
    this.freeItems,
    this.status,
    this.preOrderTimestamp,
    this.tip,
    this.tipPercent,
    this.created,
    this.isKitchen,
    this.isAcknowledge,
    this.refundAmount,
  });

  factory EmpOrderModel.fromJson(Map<String, dynamic> json) => EmpOrderModel(
    id: json['id'] as int?,
    main: (json['main'] as List<dynamic>?)
        ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
        .toList(),
    kitchen: (json['kitchen'] as List<dynamic>?)
        ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
        .toList(),
    delivery: json['delivery'],
    cafe: json['cafe'] == null
        ? null
        : CafeModel.fromJson(json['cafe'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    subTotalPrice: json['sub_total_price'] as String?,
    taxTotal: json['tax_total'] as String?,
    totalPrice: json['total_price'] as String?,
    freeItems: json['free_items'],
    status: json['status'] as String?,
    preOrderTimestamp: json['pre_order_timestamp'] as int?,
    tip: json['tip'] as String?,
    tipPercent: json['tip_percent'] as int?,
    created: json['created'] as int?,
    isKitchen: json['is_kitchen'] as bool?,
    isAcknowledge: json['is_acknowledge'] as bool?,
    refundAmount: json['refund_info'] != null
        ? json['refund_info']['refund_amount'] as String?
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'main': main?.map((e) => e.toJson()).toList(),
    'kitchen': kitchen?.map((e) => e.toJson()).toList(),
    'delivery': delivery,
    'cafe': cafe?.toJson(),
    'user': user?.toJson(),
    'sub_total_price': subTotalPrice,
    'tax_total': taxTotal,
    'total_price': totalPrice,
    'free_items': freeItems,
    'status': status,
    'pre_order_timestamp': preOrderTimestamp,
    'tip': tip,
    'tip_percent': tipPercent,
    'created': created,
    'is_kitchen': isKitchen,
    'is_acknowledge': isAcknowledge,
  };
}

class Items {
  int? id;
  List<ProductModifiers>? productModifiers;
  int? quantity;
  String? productName;
  String? productPrice;
  String? modifiersPrice;
  String? subTotalPrice;
  String? totalPrice;
  String? instruction;
  bool? isFree;
  bool? isReady;
  int? freeCount;
  dynamic freePrice;
  int? taxPercent;
  String? taxRate;
  int? order;
  int? product;
  int? productSize;

  Items({
    this.id,
    this.productModifiers,
    this.quantity,
    this.productName,
    this.productPrice,
    this.modifiersPrice,
    this.subTotalPrice,
    this.totalPrice,
    this.instruction,
    this.isFree,
    this.isReady,
    this.freeCount,
    this.freePrice,
    this.taxPercent,
    this.taxRate,
    this.order,
    this.product,
    this.productSize,
  });

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    id: json['id'] as int?,
    productModifiers: (json['product_modifiers'] as List<dynamic>?)
        ?.map((e) => ProductModifiers.fromJson(e as Map<String, dynamic>))
        .toList(),
    quantity: json['quantity'] as int?,
    productName: json['product_name'] as String?,
    productPrice: json['product_price'] as String?,
    modifiersPrice: json['modifiers_price'] as String?,
    subTotalPrice: json['sub_total_price'] as String?,
    totalPrice: json['total_price'] as String?,
    instruction: json['instruction'] as String?,
    isFree: json['is_free'] as bool?,
    isReady: json['is_ready'] as bool?,
    freeCount: json['free_count'] as int?,
    freePrice: json['free_price'],
    taxPercent: json['tax_percent'] as int?,
    taxRate: json['tax_rate'] as String?,
    order: json['order'] as int?,
    product: json['product'] as int?,
    productSize: json['product_size'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_modifiers': productModifiers?.map((e) => e.toJson()).toList(),
    'quantity': quantity,
    'product_name': productName,
    'product_price': productPrice,
    'modifiers_price': modifiersPrice,
    'sub_total_price': subTotalPrice,
    'total_price': totalPrice,
    'instruction': instruction,
    'is_free': isFree,
    'is_ready': isReady,
    'free_count': freeCount,
    'free_price': freePrice,
    'tax_percent': taxPercent,
    'tax_rate': taxRate,
    'order': order,
    'product': product,
    'product_size': productSize,
  };
}

class ProductModifiers {
  int? id;
  String? name;
  String? price;

  ProductModifiers({this.id, this.name, this.price});

  factory ProductModifiers.fromJson(Map<String, dynamic> json) =>
      ProductModifiers(
        id: json['id'] as int?,
        name: json['name'] as String?,
        price: json['price'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };
}

class User {
  int? id;
  String? phone;
  String? username;
  String? avatar;

  User({this.id, this.phone, this.username, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      phone: json['phone'] as String?,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?);

  Map<String, dynamic> toJson() =>
      {'id': id, 'phone': phone, 'username': username, 'avatar': avatar};
}
