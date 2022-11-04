import 'package:takk/data/models/company_model.dart';

import '../../data/models/company_model.dart';

abstract class CompanyRepository {

  Future<CompanyModel> getCompanyModel();
  Future<void> getCompanyInfo();
  Future<void> getCompList();
  Future<void> getCompanyCount();
  List<CompanyModel> get companiesList;

}
