import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie_hub/data/api/api_service.dart';
import '../data/models/restaurant_search.dart';
import '../utils/result_state_util.dart';


class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({required this.apiService});

  late RestaurantSearch _searchResult;
  ResultState _state = ResultState.initialState;
  String _message = '';

  String get message => _message;
  RestaurantSearch get result => _searchResult;
  ResultState get state => _state;

  Future performSearch(String query) async {
    if (query.isEmpty) {
      _state = ResultState.noData;
      notifyListeners();
      return _message = 'Search Something';
    }
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Theres No Restaurant You Searched For';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchResult = restaurant;
      }
    }on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection, Please Try Again';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
