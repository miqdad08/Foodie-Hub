import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie_hub/data/api/api_service.dart';
import 'package:foodie_hub/provider/restaurant_provider.dart';

import '../data/models/restaurant_search.dart';


class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({required this.apiService});

  late RestaurantSearch _searchResult;
  ResultState _state = ResultState.InitialState;
  String _message = '';

  String get message => _message;
  RestaurantSearch get result => _searchResult;
  ResultState get state => _state;

  Future performSearch(String query) async {
    if (query.isEmpty) {
      _state = ResultState.NoData;
      notifyListeners();
      return _message = 'Search Something';
    }
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Theres No Restaurant You Searched For';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _searchResult = restaurant;
      }
    }on SocketException {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'No Internet Connection, Please Try Again';
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
