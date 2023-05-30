import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodie_hub/data/db/database_helper.dart';
import 'package:foodie_hub/data/models/restaurant_model.dart';
import 'package:foodie_hub/presentation/detail_page.dart';
import 'package:foodie_hub/presentation/home_page.dart';
import 'package:foodie_hub/presentation/search_restaurant.dart';
import 'package:foodie_hub/presentation/splash_page.dart';
import 'package:foodie_hub/provider/database_provider.dart';
import 'package:foodie_hub/provider/pref_provider.dart';
import 'package:foodie_hub/provider/restaurant_provider.dart';
import 'package:foodie_hub/provider/restaurant_review_provider.dart';
import 'package:foodie_hub/provider/scheduling_provider.dart';
import 'package:foodie_hub/provider/search_restaurant_provider.dart';
import 'package:foodie_hub/utils/background_service.dart';
import 'package:foodie_hub/utils/navigation.dart';
import 'package:foodie_hub/utils/notification_helper.dart';
import 'package:foodie_hub/utils/pref_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/api_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotification(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (context) => RestaurantProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<RestaurantReviewProvider>(
          create: (context) => RestaurantReviewProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
            create: (context) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => SearchRestaurantProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider<PrefProvider>(
            create: (_) => PrefProvider(
                prefHelper: PrefHelper(
                    sharedPreferences: SharedPreferences.getInstance())))
      ],
      child: _materialApp(),
    );
  }

  MaterialApp _materialApp() {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          scaffoldBackgroundColor: Colors.white),
      initialRoute: SplashPage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        SplashPage.routeName: (context) => const SplashPage(),
        DetailPage.routeName: (context) => DetailPage(
              restaurant: ModalRoute.of(context)?.settings.arguments
                  as RestaurantElement,
            ),
        SearchRestaurant.routeName: (context) => const SearchRestaurant(),
      },
    );
  }
}
