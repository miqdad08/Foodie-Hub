import 'package:flutter/material.dart';
import 'package:foodie_hub/provider/search_restaurant_provider.dart';
import 'package:foodie_hub/utils/style_manager.dart';
import 'package:foodie_hub/widgets/card_search_restaurant.dart';
import 'package:provider/provider.dart';

import '../provider/restaurant_provider.dart';
import '../utils/shimmer.dart';
import '../widgets/search_widget.dart';

class SearchRestaurant extends StatelessWidget {
  static const String routeName = '/search-restaurant';

  const SearchRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchRestaurantProvider searchProvider =
        Provider.of<SearchRestaurantProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SearchWidget(
                  onChanged: (value) {
                    searchProvider.performSearch(value);
                  },
                ),
                const SizedBox(height: 24),
                _buildSearchedList(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchedList(BuildContext context) {
    return Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(child: ShimmerContainer());
      } else if (state.state == ResultState.hasData) {
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardSearchRestaurant(
                restaurant: restaurant,
              );
            });
      } else if (state.state == ResultState.noData) {
        return Center(
          child: Material(
            child: Text(
              state.message,
              style: getBlackTextStyle(),
            ),
          ),
        );
      } else if (state.state == ResultState.error) {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      } else if (state.state == ResultState.initialState) {
        return Center(
            child: Text(
          'Search Restaurant Here',
          textAlign: TextAlign.center,
          style: getBlackTextStyle(),
        ));
      } else {
        return const Center(child: Text(''));
      }
    });
  }
}
