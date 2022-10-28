import 'package:takk/data/models/company_model.dart';

import '../../data/models/company_model.dart';

abstract class CompanyRepository {
  Future<CompanyModel> getCompanyModel();

  Future<void> getCompanyInfo();

  Future<void> getCompList();

  List<CompanyModel> get companiesList;
}
