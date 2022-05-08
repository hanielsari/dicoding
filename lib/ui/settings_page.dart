// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:submissiondicoding/provider/preferences_provider.dart';
// import 'package:submissiondicoding/provider/scheduling_provider.dart';
//
// class SettingsPage extends StatelessWidget {
//   static const routeName = 'Settings';
//
//   SettingsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: BodySettingPageResto(),
//     );
//   }
// }
//
// class BodySettingPageResto extends StatelessWidget {
//   const BodySettingPageResto({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Column(children: <Widget>[
//           Container(
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(top: 30, left: 30),
//                             child: Text(
//                               'Setting Restaurant ',
//                               style: TextStyle(
//                                   fontSize: 24,
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                         padding: EdgeInsets.only(left: 20),
//                         child: Consumer<PreferencesProvider>(
//                             builder: (context, provider, child) {
//                               return ListView(
//                                 shrinkWrap: true,
//                                 children: [
//                                   Material(
//                                     child: ListTile(
//                                       title: Text(
//                                         'Restaurant Notification',
//                                         style: Theme.of(context).textTheme.subtitle1,
//                                       ),
//                                       subtitle: Text(
//                                         "Enable notification",
//                                         style: Theme.of(context).textTheme.bodyText1,
//                                       ),
//                                       trailing: Consumer<SchedulingProvider>(
//                                         builder: (context, scheduled, _) {
//                                           return Switch.adaptive(
//                                             value: provider.isDailyNotificationActive,
//                                             onChanged: (value) async {
//                                               scheduled.scheduledRestaurant(value);
//                                               provider.enableDailyNotification(value);
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }))
//                   ]))
//         ]));
//   }
// }

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:submissiondicoding/provider/scheduling_provider.dart';
import 'package:submissiondicoding/widgets/custom_dialog.dart';
import 'package:submissiondicoding/widgets/platformwidget.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
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
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}

