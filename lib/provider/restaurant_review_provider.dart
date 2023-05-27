import 'package:flutter/material.dart';
import 'package:foodie_hub/data/api/api_service.dart';
import 'package:foodie_hub/data/models/customer_review_model.dart';
import 'package:foodie_hub/provider/restaurant_provider.dart';



class RestaurantReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantReviewProvider({required this.apiService}){
    resetState();
  }

  late CustomerReviewModel _restaurantCustomerReview;
  ResultState? _state;
  String _message = '';

  String get message => _message;

  CustomerReviewModel get result => _restaurantCustomerReview;

  ResultState? get state => _state;


  void resetState(){
    _state = ResultState.initialState;
    notifyListeners();
  }

  Future<dynamic> postReviewRestaurant(
      String id, String name, String review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantPostReview = await apiService.postReviewRestaurant(id, name, review);
      restaurantPostReview.fold((error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Gagal Post Review';
      }, (data) {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantCustomerReview = data;
      });
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
