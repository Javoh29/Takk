import 'package:flutter/material.dart';
import 'package:takk/presentation/pages/auth/view/auth_page.dart';
import 'package:takk/presentation/pages/auth/view/check_code_page.dart';
import 'package:takk/presentation/pages/auth/view/create_user_page.dart';
import 'package:takk/presentation/pages/cafe/view/cafe_page.dart';
import 'package:takk/presentation/pages/cafes_map/view/cafes_map_page.dart';
import 'package:takk/presentation/pages/companies/view/companies_page.dart';
import 'package:takk/presentation/pages/favorites/view/favorites_page.dart';
import 'package:takk/presentation/pages/home/view/home_page.dart';
import 'package:takk/presentation/pages/latest_order/view/latest_orders_page.dart';
import 'package:takk/presentation/pages/ordered/view/ordered_page.dart';
import 'package:takk/presentation/pages/tariffs/view/tariffs_page.dart';
import 'package:takk/presentation/pages/settings/view/settings_page.dart';
import 'package:takk/presentation/pages/messeges/view/messeges_page.dart';

import '../pages/cart/view/cart_page.dart';
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
  static const companiesPage = '/companiesPage';
  static const cashBackStaticPage = '/cashBackStaticPage';
  static const chatPage = '/chatPage';
  static const favOrderedPage = '/favOrderedPage';
  static const orderInfoPage = '/orderInfoPage';
  static const orderedPage = '/orderedPage';
  static const confirmPage = '/confirmPage';
  static const addressPage = '/addressPage';
  static const paymentPage = '/paymentPage';
  static const cartPage = '/cartPage';

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
              countryModel: args?['country'],
            ),
          );
        case createUserPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CreateUserPage(),
          );
        case tariffsPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => TariffsPage(),
          );
        case latestOrdersPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => LatestOrdersPage(),
          );
        case cafePage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CafePage(
              cafeModel: args?['cafe_model'],
              isFavotrite: false,
            ),
          );
        case favoritesPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => FavoritesPage(),
          );
        case settingsPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => const SettingsPage(),
          );
        case messagesPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => MessagesPage(),
          );
        case orderedPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => OrderedPage(
              curTime: args?['curTime'],
              costumTime: args?['costumTime'],
              isPickUp: args?['isPickUp'],
            ),
          );
        case cartPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CartPage(
              curTime: args?['curTime'],
              costumTime: args?['costumTime'],
              isPickUp: args?['isPickUp'],
            ),
          );
        case companiesPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CompaniesPage(),
          );
        case mapPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => const CafesMapPage(),
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
