import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie_hub/data/api/api_service.dart';

import '../data/models/models.dart';

enum ResultState { initialState, loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchRestaurant();
  }

  late RestaurantModel _restaurant;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantModel get result => _restaurant;
  ResultState get state => _state;

  Future<dynamic> fetchRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurant();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurant = restaurant;
      }
    } on SocketException {
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
