import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/features/home/view_model/home_view_model.dart';
import '../view_model/favourites_view_model.dart';
import 'package:weather_forecast/main.dart';
import '../../home/view_model/home_view_model.dart';
import '../../home/view/home_screen.dart';

class FavouritesScreen extends StatefulWidget {
  final Function(String)? onSelect;
  const FavouritesScreen ({Key? key, this.onSelect}) : super(key: key);

  @override
  _FavouritesScreenState createState() {
    return _FavouritesScreenState();
  }
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouritesViewModel>(context, listen: false).loadFavourites();
    });
  }

  @override
  Widget build (BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: MyApp.globalBackgroundGradient,
      child: Padding(
        padding: EdgeInsets.only(top: h * 0.02),
        child: Consumer<FavouritesViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (model.favourites.isEmpty) {
              return Center(
                child: Text(
                  "No favourites added",
                  style: TextStyle(
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              );
            }

            return ListView.builder(
                itemCount: model.favourites.length,
                itemBuilder: (context, index) {
                  final fav = model.favourites[index];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.005),
                    child: Container(
                      height: h * 0.07,
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                      alignment: Alignment.center,
                      child: ListTile(
                        title: Text(
                          fav.city,
                          style: TextStyle(fontSize: w * 0.05),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Delete Favourite City"),
                                  content: Text("Are you sure you want to remove this city?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                      style: TextButton.styleFrom(foregroundColor: Colors.brown),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        model.deleteFavourites(fav.city);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Record deleted successfully!"),
                                              behavior: SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                                              backgroundColor: Colors.green,
                                            ),
                                        );
                                      },
                                      child: Text("Delete"),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.redAccent
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: w * 0.07,
                          ),
                        ),
                        onTap: () {
                          if (widget.onSelect != null) {
                            widget.onSelect!(fav.city);
                          }
                        },
                      ),
                    ),
                  );
                },
            );
          },
        ),
      ),
    );
  }
}