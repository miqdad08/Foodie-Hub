import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodie_hub/data/models/models.dart';
import 'package:foodie_hub/presentation/detail_page.dart';
import 'package:foodie_hub/utils/received_notification.dart';
import 'package:rxdart/rxdart.dart';

import 'navigation.dart';

final selectedNotificationSubject = BehaviorSubject<String?>();
final didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class NotificationHelper {
  static const _channelId = 'foodiehub';
  static const _channelName = 'Foodie Hub';
  static const _channelDescription = 'Foodie Hub Notification Channel';
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIos = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        print('notification payload: $payload');
      }
      selectedNotificationSubject.add(payload);
    });
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RestaurantModel restaurant,
  ) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        _channelId, _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var titleNotification = '<b>Recommendation Restaurant For You.</b>';
    var restaurantData = restaurant.restaurants;
    var randomData = Random().nextInt(restaurantData.length);
    var restaurantName = restaurantData[randomData].name;
    var bodyNotification = '$restaurantName';

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      bodyNotification,
      platformChannelSpecifics,
      payload: json.encode(restaurant.toJson()),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectedNotificationSubject.stream.listen((String? payload) async {
      var data = RestaurantModel.fromJson(json.decode(payload ?? ''));
      var restaurant = data.restaurants;
      await Navigation.intentWithData(DetailPage.routeName, restaurant);
    });
  }
}
