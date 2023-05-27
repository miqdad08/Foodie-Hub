import 'package:flutter/material.dart';
import 'package:foodie_hub/presentation/home_page.dart';
import 'package:foodie_hub/utils/style_manager.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash-page';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(
        'Foodie Hub',
        style: getBlackTextStyle(fontSize: 24),
      ),
    ));
  }
}
