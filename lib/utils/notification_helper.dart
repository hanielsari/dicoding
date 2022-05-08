import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:submissiondicoding/common/navigation.dart';
import 'package:submissiondicoding/data/detail_restaurant.dart';
import 'package:submissiondicoding/data/list_restaurant.dart';
import 'package:submissiondicoding/ui/detail_page.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  final random = Random().nextInt(20);

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantResult restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "dicoding list restaurant channel";

    print("=========================show notification==================");

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotifications = '<b> Restaurant has been Open </b>';
    var titleRestaurant = restaurant.restaurants[random].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotifications,
      titleRestaurant,
      platformChannelSpecifics,
      payload: jsonEncode(
        {'number': random, 'data': restaurant.toJson()},
      ),
    );
  }
  // void configureSelectNotificationSubject(BuildContext context, String route) {
  //   selectNotificationSubject.stream.listen(
  //         (String payload) async {
  //       var data = json.decode(payload);
  //       debugPrint("+++++++=data++++++" + data["Id"]);
  //       await Navigator.pushNamed(context, route, arguments:data["Id"]);
  //     },
  //   );
  // }
  //
  // void configureSelectNotificationSubject(BuildContext context ,String route) {
  //   selectNotificationSubject.stream.listen(
  //         (String payload) async {
  //       print('Inside selectNotif, Payload: ' + payload + ' Route: ' + route);
  //       var data = RestaurantResult.fromJson(json.decode(payload)['data']);
  //       var restaurant = data.restaurants[json.decode(payload)['random_number']];
  //       print(restaurant.name);
  //
  //       Navigator.pushNamed(context, '/detail_page', arguments: data);
  //     },
  //   );
  // }

  void configureSelectedNotificationSubject(
      String route, BuildContext context) async {
    selectNotificationSubject.stream.listen(
          (String payload) {
        var data = RestaurantResult.fromJson(json.decode(payload)['data']);
        var restaurant = data.restaurants[json.decode(payload)['number']].id;
        Navigator.pushNamed(context, route, arguments: restaurant);
      },
    );
  }
}
