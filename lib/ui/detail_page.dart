import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submissiondicoding/api/api_service.dart';
import 'package:submissiondicoding/data/list_restaurant.dart';
import 'package:submissiondicoding/db/database_helper.dart';
import 'package:submissiondicoding/provider/favorite_provider.dart';
import 'package:submissiondicoding/provider/restaurant_provider_details.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  final String id;
  final Restaurant restaurant;

  const RestaurantDetailPage({required this.id, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailRestaurantProvider>(
            create: (_) => DetailRestaurantProvider(
                service_api: ApiService(), id: restaurant.id)),
        ChangeNotifierProvider<FavoriteProvider>(
            create: (_) => FavoriteProvider(databaseHelper: DatabaseHelper())),
      ],
      child: Scaffold(
        body: _builder(context),
      ),
    );
  }

  Widget _builder(context) {
    return Consumer<DetailRestaurantProvider>(builder: (context, state, _) {
      if (state.state == DetailResultState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (state.state == DetailResultState.HasData) {
          return NestedScrollView(
              headerSliverBuilder: (context, isScrolled) {
                return [
                  SliverAppBar(
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    backgroundColor: Color(0xFFFFD740),
                    pinned: true,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Hero(
                              tag: state.detailRestaurant.restaurant.pictureId,
                              child: Image.network(
                                "https://restaurant-api.dicoding.dev/images/medium/${state.detailRestaurant.restaurant.pictureId}",
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                              )),
                          Container(
                            padding: EdgeInsets.only(top: 100.0),
                            child: Consumer<FavoriteProvider>(
                              builder: (context, provider, child) {
                                return FutureBuilder<bool>(
                                  future: provider.isFavorited(restaurant.id),
                                  builder: (context, snapshot) {
                                    var isFavorited = snapshot.data ?? false;
                                    return CircleAvatar(
                                      // backgroundColor: Colors.black12,
                                      child: isFavorited == true
                                          ? IconButton(
                                              onPressed: () =>
                                                  provider.removeFavorite(
                                                      restaurant.id),
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ))
                                          : IconButton(
                                              onPressed: () => provider
                                                  .addFavorite(restaurant),
                                              icon: const Icon(
                                                Icons.favorite_border_outlined,
                                                color: Colors.red,
                                              )),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        state.detailRestaurant.restaurant.name,
                      ),
                      centerTitle: true,
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16.0,
                                ),
                                SizedBox(width: 2.0),
                                Text(
                                  state.detailRestaurant.restaurant.city,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 6.0),
                              child: Row(children: [
                                Icon(Icons.star_rate,
                                    size: 16.0, color: Colors.yellow),
                                SizedBox(width: 2.0),
                                Text(
                                  "${state.detailRestaurant.restaurant.rating},  ",
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Icon(
                                  Icons.reviews,
                                  size: 16.0,
                                  color: Colors.red,
                                ),
                                Text(
                                  " ${state.detailRestaurant.restaurant.customerReviews.length.toString()} reviews",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ])),
                          Text("Descriptions",
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(height: 4.0),
                          Text(state.detailRestaurant.restaurant.description,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.justify),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Categories",
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: state.detailRestaurant.restaurant.categories
                            .map(
                              (cat) => Transform(
                                transform: Matrix4.identity()..scale(0.8),
                                child: Chip(
                                  label: Text(
                                    cat.name,
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  backgroundColor: Colors.amber.shade100,
                                  shape: StadiumBorder(
                                      side: BorderSide(color: Colors.green)),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Foods",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Container(
                      height: 250,
                      child: ListView.builder(
                          itemCount: state
                              .detailRestaurant.restaurant.menus.foods.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 8.0, left: 16.0, right: 16.0),
                              padding: EdgeInsets.all(8),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Color(0xffEAE2B7)),
                              child: Center(
                                child: Text(
                                  state.detailRestaurant.restaurant.menus
                                      .foods[index].name,
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Drinks",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      height: 250,
                      child: ListView.builder(
                          itemCount: state
                              .detailRestaurant.restaurant.menus.drinks.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 8.0, left: 16.0, right: 16.0),
                              padding: EdgeInsets.all(8),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Color(0xffEAE2B7)),
                              child: Center(
                                child: Text(
                                  state.detailRestaurant.restaurant.menus
                                      .drinks[index].name,
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Review",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Container(
                      child: ListView.builder(
                          itemCount: state.detailRestaurant.restaurant
                              .customerReviews.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return Card(
                              color: Colors.amber.shade50,
                              margin: EdgeInsets.only(
                                  top: 8.0, left: 16.0, right: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      state.detailRestaurant.restaurant
                                          .customerReviews[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      state.detailRestaurant.restaurant
                                          .customerReviews[index].date,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    Text(
                                      state.detailRestaurant.restaurant
                                          .customerReviews[index].review,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )
          );
        } else if (state.state == DetailResultState.Error) {
          return Center(
            child: Text("Error",
                style: Theme.of(context).textTheme.bodyText1),
          );
        } else {
          return Center(
            child: Text(''),
          );
        }
      }
    });
  }
}
//

Widget _buildIconFavorite(Restaurant restaurant) {
  return Container(
    child: Consumer<FavoriteProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurant.id),
          builder: (context, snapshot) {
            var isFavorited = snapshot.data ?? false;
            return CircleAvatar(
              backgroundColor: Colors.black12,
              child: isFavorited
                  ? IconButton(
                      icon: const Icon(Icons.favorite),
                      color: Colors.red[400],
                      onPressed: () => provider.removeFavorite(restaurant.id),
                    )
                  : IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.red[400],
                      onPressed: () => provider.addFavorite(restaurant),
                    ),
            );
          },
        );
      },
    ),
  );
}
