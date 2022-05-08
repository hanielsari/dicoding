import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:submissiondicoding/db/database_helper.dart';
import 'package:submissiondicoding/data/list_restaurant.dart';


enum FavoriteResultState { Loading, Error, NoData, HasData }

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  FavoriteProvider({required this.databaseHelper}) {
    getFavorites();
  }

  FavoriteResultState _state =FavoriteResultState.Loading;
  FavoriteResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.isNotEmpty) {
      _state = FavoriteResultState.HasData;
    } else {
      _state = FavoriteResultState.NoData;
      _message = 'Kosong';
    }
    notifyListeners();
  }


  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      getFavorites();
    } catch (e) {
      _state = FavoriteResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      getFavorites();
    } catch (e) {
      _state = FavoriteResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}