class AddressModel {
  int? id;
  String? address;
  String? latitude;
  String? longitude;
  String? instruction;

  AddressModel({
    this.id,
    this.address,
    this.latitude,
    this.longitude,
    this.instruction,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'] as int?,
        address: json['address'] as String?,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
        instruction: json['instruction'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'instruction': instruction,
      };
}
