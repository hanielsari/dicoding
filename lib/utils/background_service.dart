import 'dart:math';
import 'dart:ui';
import 'dart:isolate';
import 'package:submissiondicoding/main.dart';
import 'package:submissiondicoding/api/api_service.dart';
import 'package:submissiondicoding/utils/notification_helper.dart';
import 'notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _service;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _service = this;
  }

  factory BackgroundService() => _service ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm Started');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var result = await ApiService().getList();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
  Future<void> someTask() async {
    print('Execute some process');
  }
}
