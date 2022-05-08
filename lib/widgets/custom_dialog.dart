import 'dart:io';
import 'package:submissiondicoding/common/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

customDialog(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Coming Soon!'),
          content: Text('This feature will be coming soon!'),
          actions: [
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigation.back();
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Coming Soon!'),
          content: Text('This feature will be coming soon!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

//ListTile(
//             title: Text('Log out'),
//             trailing: Switch.adaptive(
//               value: false,
//               onChanged: (value) {
//                 defaultTargetPlatform == TargetPlatform.iOS
//                     ? showCupertinoDialog(
//                         context: context,
//                         barrierDismissible: true,
//                         builder: (context) {
//                           return CupertinoAlertDialog(
//                             title: Text('Coming Soon!'),
//                             content: Text('This feature will be coming soon!'),
//                             actions: [
//                               CupertinoDialogAction(
//                                 child: Text('Ok'),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ],
//                           );
//                         },
//                       )
//                     : showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: Text('Coming Soon!'),
//                             content: Text('This feature will be coming soon!'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Ok'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//               },
//             ),
//           ),
