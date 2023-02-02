import 'package:takk/data/models/company_model.dart';

import '../../data/models/company_model.dart';

abstract class CompanyRepository {
  Future<CompanyModel> getCompanyModel();
  Future<void> getCompanyInfo();
  Future<void> getCompList();
  Future<void> getCompanyCount();
  Future<void> givePoints(int points, String phone, int id);

  List<CompanyModel> get companiesList;
}
