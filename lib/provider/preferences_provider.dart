import 'package:flutter/material.dart';
import 'package:submissiondicoding/data/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyNotificationPreferences();
  }

  bool _isDailyNotificationActive = false;
  bool get isDailyNotificationActive => _isDailyNotificationActive;

  void _getDailyNotificationPreferences() async {
    _isDailyNotificationActive =
    await preferencesHelper.isDailyRestaurantActive;
    notifyListeners();
  }

  void enableDailyNotification(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    _getDailyNotificationPreferences();
  }
}