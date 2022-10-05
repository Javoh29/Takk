import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/core/services/custom_client.dart';
import 'package:project_blueprint/data/repositories/auth_repository_impl.dart';
import 'package:project_blueprint/data/repositories/company_repository_impl.dart';
import 'package:project_blueprint/domain/repositories/auth_repository.dart';
import 'package:project_blueprint/domain/repositories/cafe_repository.dart';
import 'package:project_blueprint/domain/repositories/company_repository.dart';

import '../../data/repositories/cafe_repository_impl.dart';
import '../../data/viewmodel/local_viewmodel.dart';

final locator = JbazaLocator.instance;

void setupLocator() {
  locator.registerSingleton<CustomClient>(CustomClient(null));
  locator.registerLazySingleton<LocalViewModel>(() => LocalViewModel(context: null));
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator.get()));
  locator.registerLazySingleton<CompanyRepository>(() => CompanyRepositoryImpl(locator.get()));
  locator.registerLazySingleton<CafeRepository>(() => CafeRepositoryImpl(locator.get()));
}
