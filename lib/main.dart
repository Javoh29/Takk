import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/company_model.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:timezone/data/latest.dart';

import 'config/theme/themes.dart';
import 'core/di/app_locator.dart';
import 'core/services/notif_service.dart';
import 'presentation/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotifService().initFirebase();
  setupConfigs(() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Hive.registerAdapter<CompanyModel>(CompanyModelAdapter());
    Hive.registerAdapter<TokenModel>(TokenModelAdapter());
    setupLocator();
    initializeTimeZones();
    runApp(const MyApp());
  }, appVersion: '1.0.0');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return MaterialApp(
      title: 'Takk App',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      supportedLocales: const <Locale>[Locale('en', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: (setting) => Routes.generateRoute(setting),
    );
  }
}
