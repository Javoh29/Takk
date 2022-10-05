import 'location.dart';
import 'working_day.dart';

class CafeModel {
  int? id;
  String? logoMedium;
  String? logoSmall;
  String? logoLarge;
  bool? isOpenNow;
  String? openingTime;
  String? closingTime;
  bool? isFavorite;
  List<dynamic>? photos;
  List<WorkingDay>? workingDays;
  String? cafeTimezone;
  String? description;
  String? callCenter;
  String? website;
  String? country;
  String? city;
  String? state;
  String? postalCode;
  String? address;
  String? secondAddress;
  int? likeCount;
  int? dislikeCount;
  int? ordersCount;
  String? logo;
  String? name;
  String? phoneCode;
  int? status;
  Location? location;
  String? taxRate;
  bool? deliveryAvailable;
  int? deliveryMaxDistance;
  String? deliveryMinAmount;
  String? deliveryFee;
  String? deliveryPercent;
  String? deliveryKmAmount;
  int? deliveryMinTime;
  int? version;
  int? orderLimit;
  int? orderTimeLimit;
  bool? squareNotifications;
  DateTime? createdDt;
  DateTime? updatedDt;
  int? company;

  CafeModel({
    this.id,
    this.logoMedium,
    this.logoSmall,
    this.logoLarge,
    this.isOpenNow,
    this.openingTime,
    this.closingTime,
    this.isFavorite,
    this.photos,
    this.workingDays,
    this.cafeTimezone,
    this.description,
    this.callCenter,
    this.website,
    this.country,
    this.city,
    this.state,
    this.postalCode,
    this.address,
    this.secondAddress,
    this.likeCount,
    this.dislikeCount,
    this.ordersCount,
    this.logo,
    this.name,
    this.phoneCode,
    this.status,
    this.location,
    this.taxRate,
    this.deliveryAvailable,
    this.deliveryMaxDistance,
    this.deliveryMinAmount,
    this.deliveryFee,
    this.deliveryPercent,
    this.deliveryKmAmount,
    this.deliveryMinTime,
    this.version,
    this.orderLimit,
    this.orderTimeLimit,
    this.squareNotifications,
    this.createdDt,
    this.updatedDt,
    this.company,
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) => CafeModel(
        id: json['id'] as int?,
        logoMedium: json['logo_medium'] as String?,
        logoSmall: json['logo_small'] as String?,
        logoLarge: json['logo_large'] as String?,
        isOpenNow: json['is_open_now'] as bool?,
        openingTime: json['opening_time'] as String?,
        closingTime: json['closing_time'] as String?,
        isFavorite: json['is_favorite'] as bool?,
        photos: json['photos'] as List<dynamic>?,
        workingDays: (json['working_days'] as List<dynamic>?)
            ?.map((e) => WorkingDay.fromJson(e as Map<String, dynamic>))
            .toList(),
        cafeTimezone: json['cafe_timezone'] as String?,
        description: json['description'] as String?,
        callCenter: json['call_center'] as String?,
        website: json['website'] as String?,
        country: json['country'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        postalCode: json['postal_code'] as String?,
        address: json['address'] as String?,
        secondAddress: json['second_address'] as String?,
        likeCount: json['like_count'] as int?,
        dislikeCount: json['dislike_count'] as int?,
        ordersCount: json['orders_count'] as int?,
        logo: json['logo'] as String?,
        name: json['name'] as String?,
        phoneCode: json['phone_code'] as String?,
        status: json['status'] as int?,
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        taxRate: json['tax_rate'] as String?,
        deliveryAvailable: json['delivery_available'] as bool?,
        deliveryMaxDistance: json['delivery_max_distance'] as int?,
        deliveryMinAmount: json['delivery_min_amount'] as String?,
        deliveryFee: json['delivery_fee'] as String?,
        deliveryPercent: json['delivery_percent'] as String?,
        deliveryKmAmount: json['delivery_km_amount'] as String?,
        deliveryMinTime: json['delivery_min_time'] as int?,
        version: json['version'] as int?,
        orderLimit: json['order_limit'] as int?,
        orderTimeLimit: json['order_time_limit'] as int?,
        squareNotifications: json['square_notifications'] as bool?,
        createdDt: json['created_dt'] == null
            ? null
            : DateTime.parse(json['created_dt'] as String),
        updatedDt: json['updated_dt'] == null
            ? null
            : DateTime.parse(json['updated_dt'] as String),
        company: json['company'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'logo_medium': logoMedium,
        'logo_small': logoSmall,
        'logo_large': logoLarge,
        'is_open_now': isOpenNow,
        'opening_time': openingTime,
        'closing_time': closingTime,
        'is_favorite': isFavorite,
        'photos': photos,
        'working_days': workingDays?.map((e) => e.toJson()).toList(),
        'cafe_timezone': cafeTimezone,
        'description': description,
        'call_center': callCenter,
        'website': website,
        'country': country,
        'city': city,
        'state': state,
        'postal_code': postalCode,
        'address': address,
        'second_address': secondAddress,
        'like_count': likeCount,
        'dislike_count': dislikeCount,
        'orders_count': ordersCount,
        'logo': logo,
        'name': name,
        'phone_code': phoneCode,
        'status': status,
        'location': location?.toJson(),
        'tax_rate': taxRate,
        'delivery_available': deliveryAvailable,
        'delivery_max_distance': deliveryMaxDistance,
        'delivery_min_amount': deliveryMinAmount,
        'delivery_fee': deliveryFee,
        'delivery_percent': deliveryPercent,
        'delivery_km_amount': deliveryKmAmount,
        'delivery_min_time': deliveryMinTime,
        'version': version,
        'order_limit': orderLimit,
        'order_time_limit': orderTimeLimit,
        'square_notifications': squareNotifications,
        'created_dt': createdDt?.toIso8601String(),
        'updated_dt': updatedDt?.toIso8601String(),
        'company': company,
      };

  CafeModel copyWith({
    int? id,
    String? logoMedium,
    String? logoSmall,
    String? logoLarge,
    bool? isOpenNow,
    String? openingTime,
    String? closingTime,
    bool? isFavorite,
    List<dynamic>? photos,
    List<WorkingDay>? workingDays,
    String? cafeTimezone,
    String? description,
    String? callCenter,
    String? website,
    String? country,
    String? city,
    String? state,
    String? postalCode,
    String? address,
    String? secondAddress,
    int? likeCount,
    int? dislikeCount,
    int? ordersCount,
    String? logo,
    String? name,
    String? phoneCode,
    int? status,
    Location? location,
    String? taxRate,
    bool? deliveryAvailable,
    int? deliveryMaxDistance,
    String? deliveryMinAmount,
    String? deliveryFee,
    String? deliveryPercent,
    String? deliveryKmAmount,
    int? deliveryMinTime,
    int? version,
    int? orderLimit,
    int? orderTimeLimit,
    bool? squareNotifications,
    DateTime? createdDt,
    DateTime? updatedDt,
    int? company,
  }) {
    return CafeModel(
      id: id ?? this.id,
      logoMedium: logoMedium ?? this.logoMedium,
      logoSmall: logoSmall ?? this.logoSmall,
      logoLarge: logoLarge ?? this.logoLarge,
      isOpenNow: isOpenNow ?? this.isOpenNow,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      isFavorite: isFavorite ?? this.isFavorite,
      photos: photos ?? this.photos,
      workingDays: workingDays ?? this.workingDays,
      cafeTimezone: cafeTimezone ?? this.cafeTimezone,
      description: description ?? this.description,
      callCenter: callCenter ?? this.callCenter,
      website: website ?? this.website,
      country: country ?? this.country,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      address: address ?? this.address,
      secondAddress: secondAddress ?? this.secondAddress,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      ordersCount: ordersCount ?? this.ordersCount,
      logo: logo ?? this.logo,
      name: name ?? this.name,
      phoneCode: phoneCode ?? this.phoneCode,
      status: status ?? this.status,
      location: location ?? this.location,
      taxRate: taxRate ?? this.taxRate,
      deliveryAvailable: deliveryAvailable ?? this.deliveryAvailable,
      deliveryMaxDistance: deliveryMaxDistance ?? this.deliveryMaxDistance,
      deliveryMinAmount: deliveryMinAmount ?? this.deliveryMinAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryPercent: deliveryPercent ?? this.deliveryPercent,
      deliveryKmAmount: deliveryKmAmount ?? this.deliveryKmAmount,
      deliveryMinTime: deliveryMinTime ?? this.deliveryMinTime,
      version: version ?? this.version,
      orderLimit: orderLimit ?? this.orderLimit,
      orderTimeLimit: orderTimeLimit ?? this.orderTimeLimit,
      squareNotifications: squareNotifications ?? this.squareNotifications,
      createdDt: createdDt ?? this.createdDt,
      updatedDt: updatedDt ?? this.updatedDt,
      company: company ?? this.company,
    );
  }
}
