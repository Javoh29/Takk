import 'cafe_model/location.dart';

class OrderModel {
  int? id;
  List<Items>? items;
  dynamic delivery;
  Cafe? cafe;
  dynamic orderUniqueId;
  String? subTotalPrice;
  String? taxTotal;
  String? totalPrice;
  dynamic freeItems;
  String? status;
  int? preOrderTimestamp;
  String? tip;
  int? tipPercent;
  bool? isConfirm;
  int? created;
  String? cashback;

  OrderModel({
    this.id,
    this.items,
    this.delivery,
    this.cafe,
    this.orderUniqueId,
    this.subTotalPrice,
    this.taxTotal,
    this.totalPrice,
    this.freeItems,
    this.status,
    this.preOrderTimestamp,
    this.tip,
    this.tipPercent,
    this.isConfirm,
    this.created,
    this.cashback,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as int?,
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
            .toList(),
        delivery: json['delivery'],
        cafe: json['cafe'] == null
            ? null
            : Cafe.fromJson(json['cafe'] as Map<String, dynamic>),
        orderUniqueId: json['order_unique_id'],
        subTotalPrice: json['sub_total_price'] as String?,
        taxTotal: json['tax_total'] as String?,
        totalPrice: json['total_price'] as String?,
        freeItems: json['free_items'],
        status: json['status'].toString().toUpperCase(),
        preOrderTimestamp: json['pre_order_timestamp'] as int?,
        tip: json['tip'] as String?,
        tipPercent: json['tip_percent'] as int?,
        isConfirm: json['is_confirm'] as bool?,
        created: json['created'] as int?,
        cashback: json['cashback'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items?.map((e) => e.toJson()).toList(),
        'delivery': delivery,
        'cafe': cafe?.toJson(),
        'order_unique_id': orderUniqueId,
        'sub_total_price': subTotalPrice,
        'tax_total': taxTotal,
        'total_price': totalPrice,
        'free_items': freeItems,
        'status': status,
        'pre_order_timestamp': preOrderTimestamp,
        'tip': tip,
        'tip_percent': tipPercent,
        'is_confirm': isConfirm,
        'created': created,
        'cashback': created,
      };
}

class Items {
  int? id;
  int? quantity;
  String? productName;
  String? productPrice;
  String? instruction;
  int? freeCount;
  dynamic freePrice;
  int? taxPercent;
  String? taxRate;
  int? order;
  int? product;
  int? productSize;
  List<dynamic>? productModifiers;

  Items({
    this.id,
    this.quantity,
    this.productName,
    this.productPrice,
    this.instruction,
    this.freeCount,
    this.freePrice,
    this.taxPercent,
    this.taxRate,
    this.order,
    this.product,
    this.productSize,
    this.productModifiers,
  });

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        id: json['id'] as int?,
        quantity: json['quantity'] as int?,
        productName: json['product_name'] as String?,
        productPrice: json['product_price'] as String?,
        instruction: json['instruction'] as String?,
        freeCount: json['free_count'] as int?,
        freePrice: json['free_price'],
        taxPercent: json['tax_percent'] as int?,
        taxRate: json['tax_rate'] as String?,
        order: json['order'] as int?,
        product: json['product'] as int?,
        productSize: json['product_size'] as int?,
        productModifiers: json['product_modifiers'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'product_name': productName,
        'product_price': productPrice,
        'instruction': instruction,
        'free_count': freeCount,
        'free_price': freePrice,
        'tax_percent': taxPercent,
        'tax_rate': taxRate,
        'order': order,
        'product': product,
        'product_size': productSize,
        'product_modifiers': productModifiers,
      };
}

class Cafe {
  int? id;
  String? name;
  String? logoSmall;
  Location? location;
  String? address;
  String? secondAddress;

  Cafe({
    this.id,
    this.name,
    this.logoSmall,
    this.location,
    this.address,
    this.secondAddress,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) => Cafe(
        id: json['id'] as int?,
        name: json['name'] as String?,
        logoSmall: json['logo_small'] as String?,
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        address: json['address'] as String?,
        secondAddress: json['second_address'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo_small': logoSmall,
        'location': location?.toJson(),
        'address': address,
        'second_address': secondAddress,
      };
}
