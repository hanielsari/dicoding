import 'package:flutter/foundation.dart';
import 'package:submissiondicoding/api/api_service.dart';
import 'package:submissiondicoding/data/list_restaurant.dart';

enum StateResultList { Loading, NoData, HasData, Error }

class ListRestaurantProvider extends ChangeNotifier {
  final ApiService service_api;

  ListRestaurantProvider({required this.service_api}) {
    fetchAllRestaurantList();
  }

  RestaurantResult? _resultRestaurantsSearch;
  String _message = '';
  StateResultList? _state;

  String get message => _message;
  RestaurantResult? get result => _resultRestaurantsSearch;
  StateResultList? get state => _state;

  Future<dynamic> fetchAllRestaurantList() async {
    try {
      _state = StateResultList.Loading;

      final restaurant = await service_api.getList();
      if (restaurant.restaurants.isEmpty) {
        _state = StateResultList.NoData;
        notifyListeners();
        return _message = 'Data Tidak Ditemukan :(';
      } else {
        _state = StateResultList.HasData;

        notifyListeners();
        return _resultRestaurantsSearch = restaurant;
      }
    } catch (error) {
      _state = StateResultList.Error;
      notifyListeners();
      return _message = 'Kamu tidak tersambung dengan internet';
    }
  }
}


