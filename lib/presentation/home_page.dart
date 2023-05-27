import 'package:flutter/material.dart';
import 'package:foodie_hub/presentation/search_restaurant.dart';
import 'package:foodie_hub/provider/restaurant_provider.dart';
import 'package:foodie_hub/utils/style_manager.dart';
import 'package:provider/provider.dart';

import '../utils/result_state_util.dart';
import '../utils/shimmer.dart';
import '../widgets/card_restaurant.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Foodie Hub',
                        style: getBlackTextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Your one stop for all your food needs.',
                        style: getBlackTextStyle(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, SearchRestaurant.routeName);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ))
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _buildList(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(child: ShimmerContainer());
      } else if (state.state == ResultState.hasData) {
        return ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(
                restaurant: restaurant,
              );
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
