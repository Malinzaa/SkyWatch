import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/home/view_model/home_view_model.dart';
import 'features/home/view/home_screen.dart';
import 'features/forecast/view_model/forecast_view_model.dart';
import 'features/forecast/view/forecast_screen.dart';
import 'features/favourites/view_model/favourites_view_model.dart';
import 'features/favourites/view/favourites_screen.dart';
import 'features/region/view_model/regionfilter_view_model.dart';
import 'features/region/view/regionfilter_screen.dart';
import 'features/settings/view_model/settings_view_model.dart';
import 'features/settings/view/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return HomeViewModel();
          }),
          ChangeNotifierProvider(create: (context) {
            return ForecastViewModel();
          }),
          ChangeNotifierProvider(create: (context) {
            return FavouritesViewModel();
          }),
          ChangeNotifierProvider(create: (context) {
            return RegionFilterViewModel();
          }),
          ChangeNotifierProvider(create: (context) {
            return SettingsViewModel();
          }),
        ],
        child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static BoxDecoration globalBackgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFF7F4E9), Color(0xFFFAF8F2)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static AppBar customAppBar(String title, {Widget? leadingIcon}) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: leadingIcon,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(
            'assets/imgs/skywatch.png',
            width: 90,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  @override
  Widget build (BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final SettingsViewModel settings = Provider.of<SettingsViewModel>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyWatch',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFA4DAE0),
          elevation: 0,
          centerTitle: true,
          toolbarHeight: h * 0.08,
          titleTextStyle: TextStyle(
            fontSize: w * 0.06,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: settings.getThemeMode(),

      home: HomeScreen(),
      initialRoute: "/",
      routes: {
        "/favourites": (context) {
          return FavouritesScreen();
        },
        "/regionFilter": (context) {
          return RegionFilterScreen();
        },
        "/settings": (context) {
          return SettingsScreen();
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/forecast") {
          final String city = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return ForecastScreen(city: city);
            },
          );
        }
        return null;
      },
    );
  }
}