import 'package:flutter/material.dart';
import 'package:foodie_hub/data/models/restaurant_model.dart';
import 'package:foodie_hub/presentation/detail_page.dart';
import 'package:foodie_hub/presentation/home_page.dart';
import 'package:foodie_hub/presentation/search_restaurant.dart';
import 'package:foodie_hub/presentation/splash_page.dart';
import 'package:foodie_hub/provider/restaurant_provider.dart';
import 'package:foodie_hub/provider/restaurant_review_provider.dart';
import 'package:foodie_hub/provider/search_restaurant_provider.dart';
import 'package:provider/provider.dart';

import 'data/api/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (context) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider<RestaurantReviewProvider>(
          create: (context) =>
              RestaurantReviewProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
            create: (_) => SearchRestaurantProvider(
                  apiService: ApiService(),
                )),
      ],
      child: _materialApp(),
    );
  }

  MaterialApp _materialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
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
