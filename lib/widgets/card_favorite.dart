import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submissiondicoding/common/style.dart';
import 'package:submissiondicoding/data/list_restaurant.dart';
import 'package:submissiondicoding/provider/favorite_provider.dart';
import 'package:submissiondicoding/ui/detail_page.dart';
import 'package:provider/provider.dart';

class CardRestaurantFavorite extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurantFavorite({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RestaurantDetailPage(
            restaurant: restaurant,
            id: 'id',
          );
        })).then((_) {
          context.read<FavoriteProvider>().getFavorites();
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 8,
          color: Colors.amber.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}"),
                          fit: BoxFit.fill),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: primaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(restaurant.city),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.stars,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text("${restaurant.rating}"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Consumer<FavoriteProvider>(
                  builder: (context, provider, child) {
                    return FutureBuilder<bool>(
                      future: provider.isFavorited(restaurant.id),
                      builder: (context, snapshot) {
                        var isFavorited = snapshot.data ?? false;
                        return CircleAvatar(
                          child: isFavorited == true
                              ? IconButton(
                                  onPressed: () =>
                                      provider.removeFavorite(restaurant.id),
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ))
                              : IconButton(
                                  onPressed: () =>
                                      provider.addFavorite(restaurant),
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
        ),
        // subtitle: Text(restaurant.city),
      ),
    );
  }
}
