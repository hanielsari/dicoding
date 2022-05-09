import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:submissiondicoding/utils/background_service.dart';
import 'package:submissiondicoding/utils/date_time_helper.dart';
import 'package:submissiondicoding/data/preferences_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  SchedulingProvider({required this.preferencesHelper}) {
     _getDailyRestaurantPreference();
  }

  bool _isScheduled = true;

  bool get isScheduled => _isScheduled;

  void _getDailyRestaurantPreference() async {
    _isScheduled = await preferencesHelper.isDailyRestaurantActive;
    notifyListeners();
  }

  void enableDailyRestaurant(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    scheduledRestaurant(value);
    _getDailyRestaurantPreference();
  }

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
          Duration(hours: 24), 1, BackgroundService.callback,
          startAt: DateTimeHelper.format(), exact: true, wakeup: true);
    } else {
      print('Scheduling Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
