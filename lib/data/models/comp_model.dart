import 'package:jbaza/jbaza.dart';

part 'comp_model.g.dart';

@HiveType(typeId: 2)
class CompanyModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? logo;
  @HiveField(4)
  String? logoResized;
  @HiveField(5)
  String loadingAppImage;
  @HiveField(6)
  String appImageMorning;
  @HiveField(7)
  String appImageDay;
  @HiveField(8)
  String appImageEvening;
  @HiveField(9)
  String? about;

  CompanyModel({
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

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
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
