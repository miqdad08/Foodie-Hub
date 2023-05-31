import 'package:flutter/material.dart';
import 'package:foodie_hub/data/api/api_service.dart';
import 'package:foodie_hub/data/models/restaurant_model.dart';
import 'package:foodie_hub/provider/restaurant_detail_provider.dart';
import 'package:foodie_hub/widgets/card_customer_review.dart';
import 'package:foodie_hub/widgets/card_menu.dart';
import 'package:foodie_hub/widgets/form_review_widget.dart';
import 'package:foodie_hub/widgets/sliver_appbar_widget.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../data/models/customer_review.dart';
import '../data/models/restaurant.dart';
import '../provider/restaurant_review_provider.dart';
import '../utils/result_state_util.dart';
import '../utils/style_manager.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail-page';

  final RestaurantElement restaurant;

  const DetailPage({super.key, required this.restaurant});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController reviewController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    final reviewProvider =
        Provider.of<RestaurantReviewProvider>(context, listen: false);
    reviewProvider.resetState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    reviewController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantDetailProvider(
          apiService: ApiService(Client()), restaurant: widget.restaurant),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return _buildScaffoldCenter(
                context, const CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            return _buildScaffold(context, state.result.restaurant);
          } else if (state.state == ResultState.noData) {
            return _buildScaffoldCenter(context, Text(state.message));
          } else if (state.state == ResultState.error) {
            return _buildScaffoldCenter(context, Text(state.message));
          } else {
            return _buildScaffoldCenter(context, Text(state.message));
          }
        },
      ),
    );
  }

  Widget _buildScaffoldCenter(BuildContext context, Widget? child) {
    return Scaffold(
      body: Center(
        child: child,
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, Restaurant restaurant) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            _buildSliverAppBar(context, restaurant),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                        ),
                        Text(
                          restaurant.city,
                          style: getBlackTextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Categories : ',
                  style: getBlackTextStyle(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildList(restaurant.categories),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Description',
                  style: getBlackTextStyle(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
                ReadMoreText(
                  restaurant.description,
                  trimCollapsedText: '...Show more',
                  trimExpandedText: ' show less',
                  style: getBlackTextStyle(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Menu',
                  style: getBlackTextStyle(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
                Text(
                  'Foods :',
                  style: getBlackTextStyle(),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildList(restaurant.menus.foods),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Drinks : ',
                  style: getBlackTextStyle(),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildList(restaurant.menus.drinks),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Review',
                  style: getBlackTextStyle(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
                _buildReviewColumn(context),
                const SizedBox(
                  height: 10,
                ),
                _buildCustomerReview(restaurant.customerReviews),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewColumn(BuildContext context) {
    return FormReviewWidget(
      nameController: nameController,
      reviewController: reviewController,
      restaurant: widget.restaurant,
    );
  }

  Consumer _buildCustomerReview(List<CustomerReview> list) {
    return Consumer<RestaurantReviewProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          return _buildListCustomerReview(state.result.customerReviews);
        } else if (state.state == ResultState.noData) {
          return Text(state.message);
        } else if (state.state == ResultState.error) {
          return Text(state.message);
        } else if (state.state == ResultState.initialState) {
          return _buildListCustomerReview(list);
        } else {
          return Text(state.message);
        }
      },
    );
  }

  Widget _buildListCustomerReview(List<CustomerReview> list) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CardCustomerReview(customerReview: list[index]);
      },
    );
  }

  SizedBox _buildList(List<dynamic> list) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return CardMenu(menu: list[index]);
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Restaurant restaurant) {
    return SliverAppBarWidget(
      restaurant: restaurant,
      restaurantElement: widget.restaurant,
    );
  }
}
