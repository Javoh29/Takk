import 'package:jbaza/jbaza.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/repositories/auth_repository_impl.dart';
import 'package:takk/data/repositories/company_repository_impl.dart';
import 'package:takk/data/repositories/create_user_repository_impl.dart';
import 'package:takk/data/repositories/favorite_repository_impl.dart';
import 'package:takk/domain/repositories/auth_repository.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/company_repository.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';

import '../../data/repositories/cafe_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/viewmodel/local_viewmodel.dart';
import '../../domain/repositories/create_user_repository.dart';
import '../../domain/repositories/user_repository.dart';

final locator = JbazaLocator.instance;

void setupLocator() {
  locator.registerSingleton<CustomClient>(CustomClient(null));
  locator.registerLazySingleton<LocalViewModel>(() => LocalViewModel(context: null));
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator.get()));
  locator.registerLazySingleton<CompanyRepository>(() => CompanyRepositoryImpl(locator.get()));
  locator.registerLazySingleton<CafeRepository>(() => CafeRepositoryImpl(locator.get()));
  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(locator.get()));
  locator.registerLazySingleton<CreateUserRepository>(() => CreateUserRepositoryImpl());
  locator.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(locator.get()));
}
