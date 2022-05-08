import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:submissiondicoding/provider/favorite_provider.dart';
import 'package:submissiondicoding/widgets/card_restaurant.dart';

import '../db/database_helper.dart';
import '../widgets/card_favorite.dart';

class RestaurantFavoritePage extends StatelessWidget {
  static const String listFavorite = 'Favorite';

  const RestaurantFavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FavoriteProvider>(
              create: (_) =>
                  FavoriteProvider(databaseHelper: DatabaseHelper())),
        ],
        child: Consumer<FavoriteProvider>(builder: (context, state, _) {
          return Scaffold(
              appBar: AppBar(
                title: Text("My Favorite Restaurant"),
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
                            height: MediaQuery.of(context).size.height,
                            child: _FavoriteList(context))),
                  ],
                ),
              ));
        }));
  }
}

@override
Widget _FavoriteList(BuildContext context) {
  return Consumer<FavoriteProvider>(
    builder: (context, state, _) {
      if (state.state == FavoriteResultState.Loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.state == FavoriteResultState.HasData) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.favorites.length,
          itemBuilder: (context, index) {
            var restaurant = state.favorites[index];
            return CardRestaurantFavorite(
              restaurant: restaurant,
            );
          },
        );
      } else if (state.state == FavoriteResultState.NoData) {
        return Center(child: Text(state.message));
      } else if (state.state == FavoriteResultState.Error) {
        return Center(child: Text(state.message));
      } else {
        return const Center(child: Text(''));
      }
    },
  );
}
