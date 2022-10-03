import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/presentation/routes/routes.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({required super.context});

  openAuthPage() async {
    navigateTo(Routes.authPage, waitTime: 2);
  }

  @override
  callBackError(String text) {}
}
