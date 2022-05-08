import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submissiondicoding/api/api_service.dart';
import 'package:submissiondicoding/common/style.dart';
import 'package:submissiondicoding/provider/restaurant_provider_search.dart';
import 'package:submissiondicoding/widgets/card_restaurant.dart';
import 'package:submissiondicoding/widgets/platformwidget.dart';

import '../data/list_restaurant.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRestaurantProvider>(
      create: (_) =>
          SearchRestaurantProvider(
            apiService: ApiService(),
          ),
      child: Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              search = '';
                            });
                          },
                        ),
                        hintText: 'Search a Menu or Restaurant',
                        border: InputBorder.none),
                    onChanged: (text) {
                      setState(() {
                        search = text;
                        context
                            .read<SearchRestaurantProvider>()
                            .fetchAllRestaurant(search);
                      });
                    },
                    onSubmitted: (text) {
                      setState(() {
                        search = text;
                        context
                            .read<SearchRestaurantProvider>()
                            .fetchAllRestaurant(search);
                      });
                    },
                  ),
                ),
              ),
            ),
            body: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: search.isEmpty
                              ? Center(child: Text(' '))
                              : _searchResultData(context),
                        ),
                      )
                    ])));
      }),
    );
  }

  Widget _searchResultData(BuildContext context) {
    return Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
      if (state.state == SearchResultState.loading) {
        return Center(child: CircularProgressIndicator());
      } else {
        if (state.state == SearchResultState.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: state.result!.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = state.result!.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              });
        } else if (state.state == SearchResultState.noData) {
          return Center(
              child: Text('Opps, restaurant yang kamu cari tidak ada',));
        } else if (state.state == SearchResultState.error) {
          return Center(child: Text(state.message,));
        } else {
          return Center(child: Text(''),
          );
        }
      }
    });
  }
}
Widget _buildAndroid(BuildContext context) {
  return Scaffold(
    body: build(context),
  );
}

Widget _buildIos(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      middle: Text('Restaurant App'),
      transitionBetweenRoutes: false,
    ),
    child: build(context),
  );
}

@override
Widget build(BuildContext context) {
  return PlatformWidget(
    androidBuilder: _buildAndroid,
    iosBuilder: _buildIos,
  );
}