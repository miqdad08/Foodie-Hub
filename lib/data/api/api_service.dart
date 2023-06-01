import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/customer_review_model.dart';
import '../models/restaurant_detail_model.dart';
import '../models/restaurant_model.dart';
import '../models/restaurant_search.dart';

class ApiService {
  final Client client;
  ApiService(this.client);

  late final String query;
  static const String imgUrl =
      'https://restaurant-api.dicoding.dev/images/small/';
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String _searchRestaurant = '/search?q=';

  Future<RestaurantModel> getRestaurant() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));
      if (response.statusCode == 200) {
        return RestaurantModel.fromJson(jsonDecode(response.body));
      } else {
        throw 'Failed to load restaurant';
      }
    } on Error {
      throw 'No Internet Connection';
    }
  }

  Future<Either<String, RestaurantDetail>> getRestaurantById(String id) async {
    final response = await client.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return Right(RestaurantDetail.fromJson(jsonDecode(response.body)));
    } else {
      return left('Failed to load restaurant');
    }
  }

  Future<Either<String, CustomerReviewModel>> postReviewRestaurant(
    String id,
    String name,
    String review,
  ) async {
    final body = json.encode({'id': id, 'name': name, 'review': review});

    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 201) {
      return Right(
        CustomerReviewModel.fromJson(
          jsonDecode(
            response.body,
          ),
        ),
      );
    } else {
      return left('Failed to load restaurant');
    }
  }

  Future<RestaurantSearch> searchRestaurant(String query) async {
    final response =
        await client.get(Uri.parse('${_baseUrl + _searchRestaurant}$query'));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant');
    }
  }
}
