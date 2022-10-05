import 'package:project_blueprint/data/models/token_model.dart';

abstract class AuthRepository {
  const AuthRepository();
  Future<TokenModel> updateToken();
}
