import 'package:flutter/material.dart';

import '../utils/pref_helper.dart';

class PrefProvider extends ChangeNotifier {
  PrefHelper prefHelper;

  PrefProvider({required this.prefHelper}) {
    _getDailyNotif();
  }

  bool _isDailyNewsActive = false;
  bool get isDailyNewsActive => _isDailyNewsActive;

  void _getDailyNotif() async {
    _isDailyNewsActive = await prefHelper.isDailyNotifActive;
    notifyListeners();
  }

  void enableDailyNotif(bool value) {
    prefHelper.setDailyNotif(value);
    _getDailyNotif();
  }
}
