import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/models.dart';
import '../provider/restaurant_review_provider.dart';
import '../utils/style_manager.dart';

class FormReviewWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController reviewController;
  final RestaurantElement restaurant;

  const FormReviewWidget(
      {Key? key,
      required this.nameController,
      required this.reviewController,
      required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Write a Review',
          style: getBlackTextStyle(),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: nameController,
          maxLines: 1,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your Name',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: reviewController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your review',
          ),
        ),
        const SizedBox(height: 10),
        Consumer<RestaurantReviewProvider>(builder: (context, state, _) {
          return ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  reviewController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all the fields'),
                  ),
                );
              } else {
                state.postReviewRestaurant(
                  restaurant.id,
                  nameController.text,
                  reviewController.text,
                );
                nameController.clear();
                reviewController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review Submitted'),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          );
        }),
      ],
    );
  }
}
