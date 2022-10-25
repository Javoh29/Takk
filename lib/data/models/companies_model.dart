class CompaniesModel {
  int? id;
  String? name;
  String? phone;
  String? logo;
  String? logoResized;
  String loadingAppImage;
  String appImageMorning;
  String appImageDay;
  String appImageEvening;
  String? about;

  CompaniesModel({
    this.id,
    this.name,
    this.phone,
    this.logo,
    this.logoResized,
    required this.loadingAppImage,
    required this.appImageMorning,
    required this.appImageDay,
    required this.appImageEvening,
    this.about,
  });

  factory CompaniesModel.fromJson(Map<String, dynamic> json) => CompaniesModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    phone: json['phone'] as String?,
    logo: json['logo'] as String?,
    logoResized: json['logo_resized'] as String?,
    loadingAppImage: json['loading_app_image'] as String,
    appImageMorning: json['app_image_morning'] as String,
    appImageDay: json['app_image_day'] as String,
    appImageEvening: json['app_image_evening'] as String,
    about: json['about'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'logo': logo,
    'logo_resized': logoResized,
    'loading_app_image': loadingAppImage,
    'app_image_morning': appImageMorning,
    'app_image_day': appImageDay,
    'app_image_evening': appImageEvening,
    'about': about,
  };
}
