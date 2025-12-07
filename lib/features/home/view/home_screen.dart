import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/core/services/db_service.dart';
import '../view_model/home_view_model.dart';
import 'package:weather_forecast/main.dart';
import '../../settings/view_model/settings_view_model.dart';
import '../../favourites/view/favourites_screen.dart';
import '../../region/view/regionfilter_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen ({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _cityController = TextEditingController();
  int _selectedIndex = 0;
  final List<String> _titles = ["SkyWatch", "Your Favourites", "Filter by Region"];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lastCity = await Provider.of<HomeViewModel>(context, listen: false)
          .loadLastCity();

      if (lastCity != null && lastCity.isNotEmpty) {
        Provider.of<HomeViewModel>(context, listen: false)
            .fetchWeather(lastCity);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages(double w, double h) {
    return [
      _homeTab(w, h),
      FavouritesScreen(
        onSelect: (city) {
          Provider.of<HomeViewModel>(context, listen: false).fetchWeather(city);
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      RegionFilterScreen(
        onSelect: (city) {
          Provider.of<HomeViewModel>(context, listen: false).fetchWeather(city);
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
    ];
  }


  @override
  Widget build (BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final pages = _pages(w, h);

    return Scaffold(
      appBar: MyApp.customAppBar(
        _titles[_selectedIndex],
        leadingIcon: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settings");
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),

      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFFAF8F2),
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF5EB9BF),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 16),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 30,
            ),
            label: "Favourites",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_alt,
              size: 30,
            ),
            label: "Region",
          ),
        ],
      ),
    );
  }
  Widget _homeTab (double w, double h) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: MyApp.globalBackgroundGradient,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all (w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.02),
              TextField(
                controller: _cityController,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black
                ),
                decoration: InputDecoration(
                  hintText: "Enter city name",
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      String city = _cityController.text.trim();
                      if (city.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        Provider.of<HomeViewModel> (context, listen: false).fetchWeather(city);
                      }
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),

              Consumer<HomeViewModel>(
                  builder: (context, model, child) {
                    if (model.isLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: h *
                            0.1),
                        child: Center(child: CircularProgressIndicator(
                            color: Colors.blueAccent)),
                      );
                    } else if (model.errorMessage.isNotEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: h *
                            0.1),
                        child: Center(
                          child: Text(
                            model.errorMessage,
                            style: TextStyle(color: Colors.red,
                                fontSize: w * 0.05),
                          ),
                        ),
                      );
                    } else if (model.weather == null) {
                      return Text(
                        "Search a city to see weather details",
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      );
                    } else {
                      var weather = model.weather!;
                      final settings = Provider.of<SettingsViewModel> (context);
                      bool isDark = Theme.of(context).brightness == Brightness.dark;
                      Color mainTextColor = isDark? Colors.white : Colors.black;
                      Color titleTextColor = isDark? Colors.white70 : Color(0xFF693A12);
                      Color descriptionTextColor = isDark? Colors.white : Colors.black87;

                      double displayedTemp = weather.temperature;
                      if (!settings.isCelcius) {
                        displayedTemp = (displayedTemp * 9/5) + 32;
                      }
                      String tempText = displayedTemp.toStringAsFixed(1) + (settings.isCelcius ? " C" : " F");

                      double displayedWind = weather.windSpeed;
                      if (!settings.isMS) {
                        displayedWind = displayedWind * 3.6;
                      }
                      String windText = displayedWind.toStringAsFixed(1) + (settings.isMS ? " m/s" : " km/h");

                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.05),
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Color(0xFFE8E7E6).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 6),
                                  )
                                ]
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Image.network(
                                      "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
                                      width: w * 0.3,
                                      height: w * 0.3,
                                    ),
                                    Text(
                                      weather.cityName,
                                      style: TextStyle(
                                        fontSize: w * 0.07,
                                        fontFamily: 'Inter',
                                        color: titleTextColor,
                                      ),
                                    ),
                                    SizedBox(height: h * 0.01),
                                    Text(
                                      weather.description,
                                      style: TextStyle(
                                        fontSize: w * 0.05,
                                        fontWeight: FontWeight.w600,
                                        color: descriptionTextColor,
                                      ),
                                    ),
                                    SizedBox(height: h * 0.01),
                                    Text(
                                      "Temperature: " + tempText,
                                      style: TextStyle(
                                        fontSize: w * 0.05,
                                        color: mainTextColor,
                                      ),
                                    ),
                                    SizedBox(height: h * 0.01),
                                    Text(
                                      "Humidity: " + weather.humidity.toString() + "%",
                                      style: TextStyle(
                                        fontSize: w * 0.05,
                                        color: mainTextColor,
                                      ),
                                    ),
                                    SizedBox(height: h * 0.01),
                                    Text(
                                      "Wind Speed: " + windText,
                                      style: TextStyle(
                                        fontSize: w * 0.05,
                                        color: mainTextColor,
                                      ),
                                    ),
                                    SizedBox(height: h * 0.03),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, "/forecast",
                                                  arguments: weather.cityName);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFFF0F0F0),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 0.014),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                                "View Forecast",
                                                style: TextStyle(
                                                    color: Colors.brown,
                                                    fontSize: w * 0.045)
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: w * 0.03),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await DatabaseService.instance
                                                  .addFavourite(weather.cityName);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(weather.cityName + " added to favourites"),
                                                  backgroundColor: Colors.green,
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFFF0F0F0),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: h * 0.014),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              "Add to Favourites",
                                              style: TextStyle(
                                                  color: Colors.brown,
                                                  fontSize: w * 0.045),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: h * 0.09),
                                      ],
                                    ),
                                  ],
                                ),
                                if (settings.notificationsEnabled && weather.alerts.isNotEmpty)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        List<String> alertList = weather.alerts;

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Weather Alerts",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              content: Container(
                                                width: double.maxFinite,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: alertList
                                                      .map((a) {
                                                    return ListTile(
                                                      leading: Icon(
                                                          Icons.warning_amber_rounded,
                                                          color: Colors.red
                                                      ),
                                                      title: Text(a),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Close"),
                                                  style: TextButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      backgroundColor: Colors.brown),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.white,
                                          size: w * 0.07,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.05),
                        ],
                      );
                    };
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}