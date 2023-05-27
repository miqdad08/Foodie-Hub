import 'package:flutter/material.dart';

import '../utils/style_manager.dart';

class CardMenu extends StatelessWidget {
  final dynamic menu;
  const CardMenu({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey.withOpacity(0.2),
      ),
      margin: const EdgeInsets.only(right: 10),
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Text(
          menu.name,
          style: getBlackTextStyle(
              fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
