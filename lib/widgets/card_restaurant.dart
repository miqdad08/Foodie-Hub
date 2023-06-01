import 'package:flutter/material.dart';
import 'package:foodie_hub/data/api/api_service.dart';
import 'package:foodie_hub/presentation/detail_page.dart';
import '../data/models/models.dart';
import '../utils/style_manager.dart';

class CardRestaurant extends StatelessWidget {
  final RestaurantElement restaurant;

  const CardRestaurant({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              DetailPage.routeName,
              arguments: restaurant,
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                        const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Hero(
                      tag: restaurant.pictureId,
                      child: FadeInImage(
                        image: NetworkImage(
                            ApiService.imgUrl + restaurant.pictureId
                        ),
                        placeholder: const AssetImage('assets/images/grey.png'),
                        height: 150,
                        width: 145,
                        fit: BoxFit.cover,
                      ),
                      ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        restaurant.name,
                        style: getBlackTextStyle(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        restaurant.description,
                        style: getBlackTextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 17,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.city,
                            style: getBlackTextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
    //   FutureBuilder(
    //   future: state.isFavorited(restaurant.id),
    //   builder: (context, snapshot) {
    //     var isFavorited = snapshot.data ?? false;
    //     print(isFavorited);
    //     return
    //   }
    // );
  }
}
