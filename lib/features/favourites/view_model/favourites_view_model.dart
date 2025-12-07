import 'package:flutter/material.dart';
import '../../../core/services/db_service.dart';
import '../model/favourites_model.dart';

class FavouritesViewModel extends ChangeNotifier {
  List<FavouritesModel> favourites = [];
  bool isLoading = false;

  void loadFavourites() async {
    isLoading = true;
    notifyListeners();

    final data = await DatabaseService.instance.getFavourites();

    favourites = data.map((item) {
      return FavouritesModel.fromJson(item);
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  void deleteFavourites(String city) async {
    await DatabaseService.instance.removeFavourite(city);
    loadFavourites();
  }
}