import '../../data/models/comp_model.dart';

abstract class CompanyRepository {
  const CompanyRepository();
  Future<CompanyModel> getCompanyModel();
  Future<void> getCompanyInfo();
}
