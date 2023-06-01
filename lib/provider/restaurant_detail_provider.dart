import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:foodie_hub/data/api/api_service.dart';
import '../data/models/models.dart';
import '../utils/result_state_util.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  RestaurantElement restaurant;
  final ApiService apiService;

  RestaurantDetailProvider(
      {required this.apiService, required this.restaurant}) {
    fetchDetailRestaurant();
  }

  late RestaurantDetail _restaurantDetail;

  late ResultState _state = ResultState.initialState;
  String _message = '';

  String get message => _message;

  RestaurantDetail get result => _restaurantDetail;

  ResultState get state => _state;

  Future<dynamic> fetchDetailRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail =
          await apiService.getRestaurantById(restaurant.id);
      restaurantDetail.fold((error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      }, (data) {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = data;
      });
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
