import 'dart:convert';
import 'models.dart';

RestaurantSearch restaurantSearchFromJson(String str) => RestaurantSearch.fromJson(json.decode(str));

String restaurantSearchToJson(RestaurantSearch data) => json.encode(data.toJson());

class RestaurantSearch {
    final bool error;
    final int founded;
    final List<RestaurantElement> restaurants;

    RestaurantSearch({
        required this.error,
        required this.founded,
        required this.restaurants,
    });

    factory RestaurantSearch.fromJson(Map<String, dynamic> json) => RestaurantSearch(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantElement>.from(json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
}
