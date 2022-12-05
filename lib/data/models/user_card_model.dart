class UserCardModel {
  int? id;
  String? brand;
  String? last4;
  String? name;

  UserCardModel({this.id, this.brand, this.last4, this.name});

  factory UserCardModel.fromJson(Map<String, dynamic> json) => UserCardModel(
        id: json['id'] as int?,
        brand: json['brand'] as String?,
        last4: json['last4'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'last4': last4,
        'name': name,
      };
}
