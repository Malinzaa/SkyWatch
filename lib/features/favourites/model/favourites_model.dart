class FavouritesModel {
  final String city;

  FavouritesModel ({
    required this.city
  });

  factory FavouritesModel.fromJson (Map<String, dynamic>json) {
    return FavouritesModel(
      city: json['city'] ??"",
    );
  }
}