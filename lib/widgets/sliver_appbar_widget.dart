import 'package:flutter/material.dart';
import 'package:foodie_hub/provider/database_provider.dart';
import 'package:provider/provider.dart';
import '../data/api/api_service.dart';
import '../data/models/models.dart';
import '../utils/style_manager.dart';

class SliverAppBarWidget extends StatelessWidget {
  final Restaurant restaurant;
  final RestaurantElement restaurantElement;

  const SliverAppBarWidget({Key? key, required this.restaurant, required this.restaurantElement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 230,
      backgroundColor: Colors.black,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CircleAvatar(
          radius: 2,
          backgroundColor: Colors.black.withOpacity(0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0, 0, 1],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Hero(
            tag: restaurant.pictureId,
            child: Image.network(
              '${ApiService.imgUrl}${restaurant.pictureId}',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                restaurant.name,
                style: getWhiteTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Consumer<DatabaseProvider>(builder: (context, state, _) {
              return FutureBuilder(
                future: state.isFavorited(restaurant.id),
                builder: (context, snapshot) {
                  var isFavorited = snapshot.data ?? false;
                  return Expanded(
                    child: isFavorited
                        ? IconButton(
                            icon: const Icon(Icons.bookmark),
                            color: Colors.red,
                            onPressed: () =>
                                state.removeFavorite(restaurant.id),
                          )
                        : IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            color: Colors.grey,
                            onPressed: () => state.addFavorite(restaurantElement),
                          ),
                  );
                },
              );
            }),
          ],
        ),
        // titlePadding: const EdgeInsets.only(top: 16, left: 20),
      ),
    );
  }
}
