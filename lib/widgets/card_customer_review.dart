import 'package:flutter/material.dart';

import '../data/models/models.dart';

class CardCustomerReview extends StatelessWidget {
  final CustomerReview customerReview;
  const CardCustomerReview({Key? key, required this.customerReview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        tileColor: Colors.grey.withOpacity(0.2),
        title: Text(customerReview.name),
        trailing: Text(customerReview.date),
        subtitle: Text(customerReview.review),
      ),
    );
  }
}
