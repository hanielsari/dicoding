import 'package:flutter/material.dart';
import 'package:submissiondicoding/data/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  bool _isDailyRestaurantActive = false;

  bool get isDailyRestaurantActive => _isDailyRestaurantActive;

  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyNotificationPreferences();
  }


  void _getDailyNotificationPreferences() async {
    _isDailyRestaurantActive =
    await preferencesHelper.isDailyRestaurantActive;
    notifyListeners();
  }

  void enableDailyNotification(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    _getDailyNotificationPreferences();
  }
}
