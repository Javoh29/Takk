import 'package:flutter/material.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/auth/view/auth_page.dart';
import 'package:takk/presentation/pages/auth/view/check_code_page.dart';
import 'package:takk/presentation/pages/auth/view/create_user_page.dart';
import 'package:takk/presentation/pages/cafe/view/cafe_page.dart';
import 'package:takk/presentation/pages/favorites/view/favorites_page.dart';
import 'package:takk/presentation/pages/home/view/home_page.dart';
import 'package:takk/presentation/pages/settings/view/settings_page.dart';

import '../pages/splash/view/splash_page.dart';

class Routes {
  static const splashPage = '/';
  static const homePage = '/homePage';
  static const authPage = '/authPage';
  static const checkCodePage = '/checkCodePage';
  static const createUserPage = '/createUserPage';
  static const tariffsPage = '/tariffsPage';
  static const latestOrdersPage = '/latestOrdersPage';
  static const favoritesPage = '/favoritesPage';
  static const ordersPage = '/ordersPage';
  static const messagesPage = '/messagesPage';
  static const settingsPage = '/settingsPage';
  static const mapPage = '/mapPage';
  static const cafePage = '/cafePage';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic>? args = routeSettings.arguments as Map<String, dynamic>?;
      args ?? <String, dynamic>{};
      switch (routeSettings.name) {
        case splashPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SplashPage(),
          );
        case authPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AuthPage(),
          );
        case homePage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => HomePage(),
          );
        case checkCodePage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CheckCodePage(
              phoneNumber: args?['phone'],
              countryModel: args?['country']
            ),
          );
        case createUserPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CreateUserPage(),
          );
        case cafePage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CafePage(cafeModel: locator<LocalViewModel>().listCafes[0], isFavotrite: false),
          );
        case favoritePage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => FavoritesPage(),
          );
        case settingsPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SettingsPage(),
          );
        default:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => SplashPage(),
          );
      }
    } catch (e) {
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SplashPage(),
      );
    }
  }
}
