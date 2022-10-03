import 'package:jbaza/jbaza.dart';

import '../../data/viewmodel/local_viewmodel.dart';

final locator = JbazaLocator.instance;

void setupLocator() {
  locator.registerLazySingleton<LocalViewModel>(() => LocalViewModel(context: null));
}