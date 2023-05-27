import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie_hub/data/api/api_service.dart';

import '../data/models/models.dart';

enum ResultState { InitialState, Loading, NoData, HasData, Error }

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
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurant();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurant = restaurant;
      }
    } on SocketException {
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
