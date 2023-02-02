class Company {
  int? id;
  String? name;
  String? phone;
  bool? isOnline;
  String? logo;
  String? logoSmall;
  String? logoMedium;
  String? logoLarge;

  Company({
    this.id,
    this.name,
    this.phone,
    this.isOnline,
    this.logo,
    this.logoSmall,
    this.logoMedium,
    this.logoLarge,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['id'] as int?,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        isOnline: json['is_online'] as bool?,
        logo: json['logo'] as String?,
        logoSmall: json['logo_small'] as String?,
        logoMedium: json['logo_medium'] as String?,
        logoLarge: json['logo_large'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'is_online': isOnline,
        'logo': logo,
        'logo_small': logoSmall,
        'logo_medium': logoMedium,
        'logo_large': logoLarge,
      };

  Company copyWith({
    int? id,
    String? name,
    String? phone,
    bool? isOnline,
    String? logo,
    String? logoSmall,
    String? logoMedium,
    String? logoLarge,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isOnline: isOnline ?? this.isOnline,
      logo: logo ?? this.logo,
      logoSmall: logoSmall ?? this.logoSmall,
      logoMedium: logoMedium ?? this.logoMedium,
      logoLarge: logoLarge ?? this.logoLarge,
    );
  }
}
