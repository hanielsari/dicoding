import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submissiondicoding/common/style.dart';
import 'package:submissiondicoding/data/list_restaurant.dart';
import 'package:submissiondicoding/db/database_helper.dart';
import 'package:submissiondicoding/provider/favorite_provider.dart';
import 'package:submissiondicoding/provider/preferences_provider.dart';
import 'package:submissiondicoding/provider/scheduling_provider.dart';
import 'package:submissiondicoding/ui/detail_page.dart';
import 'package:submissiondicoding/ui/home.dart';
import 'package:submissiondicoding/ui/search.dart';
import 'package:submissiondicoding/utils/background_service.dart';
import 'package:submissiondicoding/utils/notification_helper.dart';

import 'data/preferences_helper.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                FavoriteProvider(databaseHelper: DatabaseHelper()),
          ),
          ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider(
                preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            )),
          ),
          ChangeNotifierProvider<PreferencesProvider>(
            create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance(),
              ),
            ),
          ),
        ],
        child:
            Consumer<PreferencesProvider>(builder: (context, provider, child) {
          return MaterialApp(
              title: 'Restaurant App',
              theme: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: primaryColor,
                      onPrimary: Colors.black,
                      secondary: secondaryColor,
                    ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: secondaryColor,
                  unselectedItemColor: Colors.grey,
                ),
              ),
              initialRoute: HomePage.routeName,
              routes: {
                HomePage.routeName: (context) => HomePage(),
                RestaurantDetailPage.routeName: (context) =>
                    RestaurantDetailPage(
                      restaurant: ModalRoute.of(context)?.settings.arguments
                          as Restaurant,
                    ),
                SearchPage.routeName: (context) => SearchPage(),
              });
        }));
  }
}


