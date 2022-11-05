import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:takk/presentation/pages/about/view/about_page.dart';
import 'package:takk/presentation/pages/auth/view/auth_page.dart';
import 'package:takk/presentation/pages/auth/view/check_code_page.dart';
import 'package:takk/presentation/pages/auth/view/create_user_page.dart';
import 'package:takk/presentation/pages/cafe/view/cafe_page.dart';
import 'package:takk/presentation/pages/cafe_info/view/cafe_info_page.dart';
import 'package:takk/presentation/pages/cafes_map/view/cafes_map_page.dart';
import 'package:takk/presentation/pages/cart/view/cart_page.dart';
import 'package:takk/presentation/pages/cashback_statistic/view/cashback_statistics_page.dart';
import 'package:takk/presentation/pages/chat/view/chat_page.dart';
import 'package:takk/presentation/pages/companies/view/companies_page.dart';
import 'package:takk/presentation/pages/fav_ordered_page/view/fav_ordered_page.dart';
import 'package:takk/presentation/pages/favorite_edit/view/favorite_edit_page.dart';
import 'package:takk/presentation/pages/favorites/view/favorites_page.dart';
import 'package:takk/presentation/pages/home/view/home_page.dart';
import 'package:takk/presentation/pages/latest_order/view/latest_orders_page.dart';
import 'package:takk/presentation/pages/ordered/view/ordered_page.dart';
import 'package:takk/presentation/pages/order_info_page/view/order_info_page.dart';
import 'package:takk/presentation/pages/orders/view/orders_page.dart';
import 'package:takk/presentation/pages/payment/view/payment_page.dart';
import 'package:takk/presentation/pages/tariffs/view/tariffs_page.dart';
import 'package:takk/presentation/pages/settings/view/settings_page.dart';
import 'package:takk/presentation/pages/messeges/view/messeges_page.dart';
import '../pages/cafe/view/pick_cafe_page.dart';
import '../pages/notification/view/notif_page.dart';
import '../pages/splash/view/splash_page.dart';

class Routes {
  static const splashPage = '/';
  static const homePage = '/homePage';
  static const authPage = '/authPage';
  static const aboutPage = '/aboutPage';
  static const notifPage = '/notifPage';
  static const paymentPage = '/paymentPage';
  static const checkCodePage = '/checkCodePage';
  static const createUserPage = '/createUserPage';
  static const tariffsPage = '/tariffsPage';
  static const latestOrdersPage = '/latestOrdersPage';
  static const favoritesPage = '/favoritesPage';
  static const favoriteEditPage = '/favoriteEditPage';
  static const ordersPage = '/ordersPage';
  static const messagesPage = '/messagesPage';
  static const settingsPage = '/settingsPage';
  static const mapPage = '/mapPage';
  static const cafePage = '/cafePage';
  static const cafeInfoPage = '/cafeInfoPage';
  static const companiesPage = '/companiesPage';
  static const cashBackStaticPage = '/cashBackStaticPage';
  static const chatPage = '/chatPage';
  static const favOrderedPage = '/favOrderedPage';
  static const orderInfoPage = '/orderInfoPage';
  static const orderedPage = '/orderedPage';
  static const confirmPage = '/confirmPage';
  static const addressPage = '/addressPage';
  static const pickCafePage = '/pickCafePage';
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
        case aboutPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => const AboutPage(),
          );
        case notifPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => NotifPage(),
          );
        case paymentPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PaymentPage(
              isSelect: args?['isPayment'],
            ),
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
        case pickCafePage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => const PickCafePage(),
          );
        case cashBackStaticPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CashbackStatisticsPage(),
          );
        case latestOrdersPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => LatestOrdersPage(),
          );
        case cafePage:
          return MaterialWithModalsPageRoute(
            settings: routeSettings,
            builder: (_) => CafePage(cafeModel: args?['cafe_model'], isFavotrite: args?['isFav']),
          );
        case favoritesPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => FavoritesPage(),
          );
        case favoriteEditPage:
          return MaterialWithModalsPageRoute(
            settings: routeSettings,
            builder: (_) => FavoriteEditPage(
              id: args?['cafeId'],
              title: args?['title'],
            ),
          );
        case settingsPage:
          return MaterialWithModalsPageRoute(
            settings: routeSettings,
            builder: (_) => SettingsPage(),
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
              costumTime: args?['custumTime'],
              curTime: args?['curTime'],
              isPickUp: args?['isPickUp'],
            ),
          );
        case companiesPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CompaniesPage(),
          );
        case chatPage:
          return MaterialPageRoute(
            settings: routeSettings,
            // TODO: fix
            builder: (_) => ChatPage(
                compId: args?["compId"],
                chatId: args?["chatId"],
                name: args?['name'],
                image: args?['image'],
                isCreate: args?['isCreate'],
                isOrder: args?['isOrder']),
          );
        case mapPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CafesMapPage(),
          );
        case favOrderedPage:
          return MaterialPageRoute(builder: (_) => FavOrderedPage(args?['cafeRes'], args?['isFav']));
        case cafeInfoPage:
          return MaterialPageRoute(settings: routeSettings, builder: (_) => CafeInfoPage(args?['cafeInfoModel']));
        case ordersPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => OrdersPage(),
          );
        case orderInfoPage:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => OrderInfoPage(eModel: args?['model'], eType: args?['type']),
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
