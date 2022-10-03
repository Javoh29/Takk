import '../../data/models/comp_model.dart';

abstract class AuthRepository {
  Future<CompanyModel> getCompanyModel();
}
