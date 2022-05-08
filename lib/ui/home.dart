import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submissiondicoding/ui/account.dart';
import 'package:submissiondicoding/ui/list_favorite.dart';
import 'package:submissiondicoding/ui/restaurantlist.dart';
import 'package:submissiondicoding/ui/settings_page.dart';
import 'package:submissiondicoding/widgets/platformwidget.dart';
import 'package:submissiondicoding/utils/notification_helper.dart';
import 'package:submissiondicoding/ui/detail_page.dart';
import 'package:submissiondicoding/utils/background_service.dart';


class HomePage extends StatefulWidget {
  static const routeName = '/restaurant_list';


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  static const String _homeText = 'Home';
  final BackgroundService _service = BackgroundService();
  final NotificationHelper _notificationHelper = NotificationHelper();

  List<Widget> _listWidget = [
    RestaurantList(),
    RestaurantFavoritePage(),
    SettingsPage(),
    AccountPage(),
  ];


  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectedNotificationSubject(
        RestaurantDetailPage.routeName, context);
  }


  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.home : Icons.home),
      label: _homeText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS
          ? CupertinoIcons.square_favorites_alt
          : Icons.favorite),
      label: RestaurantFavoritePage.listFavorite,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS
          ? CupertinoIcons.settings
          : Icons.settings),
      label: SettingsPage.settingsTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(
          Platform.isIOS ? CupertinoIcons.person_crop_circle : Icons.person),
      label: AccountPage.accountTitle,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: CupertinoColors.black,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomNavBarItems,
        activeColor: CupertinoColors.black,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
