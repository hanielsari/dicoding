import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:submissiondicoding/provider/scheduling_provider.dart';
import 'package:submissiondicoding/widgets/custom_dialog.dart';
import 'package:submissiondicoding/provider/preferences_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String settingsTitle = 'Settings';

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    {
      return Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (value) => customDialog(context),
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: Text('Scheduling News'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                        value: scheduled.isScheduled,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            customDialog(context);
                          } else {
                            scheduled.scheduledRestaurant(value);
                            scheduled.enableDailyRestaurant(value);
                          }
                        });
                  },
                ),
              ),
            ),
          ],
        );
      });
    } //ListView(
  }
}
