import 'dart:convert';

import 'customer_review.dart';

CustomerReviewModel customerReviewModelFromJson(String str) => CustomerReviewModel.fromJson(json.decode(str));

String customerReviewModelToJson(CustomerReviewModel data) => json.encode(data.toJson());

class CustomerReviewModel {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  CustomerReviewModel({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) => CustomerReviewModel(
    error: json["error"],
    message: json["message"],
    customerReviews: List<CustomerReview>.from(json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "customerReviews": List<dynamic>.from(customerReviews.map((x) => x.toJson())),
  };
}


