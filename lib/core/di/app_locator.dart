import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/data/repositories/auth_repository_impl.dart';
import 'package:project_blueprint/domain/repositories/auth_repository.dart';

import '../../data/viewmodel/local_viewmodel.dart';

final locator = JbazaLocator.instance;

void setupLocator() {
  locator.registerLazySingleton<LocalViewModel>(() => LocalViewModel(context: null));
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}
