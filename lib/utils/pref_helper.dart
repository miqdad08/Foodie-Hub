import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  final Future<SharedPreferences> sharedPreferences;

  PrefHelper({required this.sharedPreferences});

  static const dailyNotif = 'DAILY_NOTIF';

  Future<bool> get isDailyNotifActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyNotif) ?? false;
  }

  void setDailyNotif(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyNotif, value);
  }
}
