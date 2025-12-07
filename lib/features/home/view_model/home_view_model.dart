import 'package:flutter/material.dart';
import '../model/weather_model.dart';
import '../../../core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  WeatherModel? weather;
  bool isLoading = false;
  String errorMessage = '';

  List<String> alerts = [];

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final response = await _apiService.getCurrentWeather(city);
      weather = WeatherModel.fromJson(response.data);

      try {
        final alertData = await _apiService.getWeatherAlerts(weather!.lat, weather!.lon);
        if (alertData.containsKey('alerts') && alertData['alerts'] != null) {
          List<String> apiAlerts = List<String>.from(
            alertData['alerts'].map((a) {
              a['event'].toString();
            })
          );
          if (apiAlerts.isNotEmpty) {
            weather!.alerts = apiAlerts;
          } else {
            await fetchAlerts(city);
            weather!.alerts = alerts;
          }
        } else {
          await fetchAlerts(city);
          weather!.alerts = alerts;
        }

      } catch (e) {
        await fetchAlerts(city);
        weather!.alerts = alerts;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_city', city);

    } catch (e) {
      errorMessage = "Could not fetch weather for $city";
      weather = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchAlerts (String city) async {
    await Future.delayed(Duration(milliseconds: 200));
    if (city.toLowerCase() == "colombo") {
      alerts = [
        "Heavy rain expected tomorrow",
        "Strong winds up to 20 m/s today"
      ];
    } else {
      alerts = ["No alerts for this location"];
    }
  }

  Future<void> saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }

  Future<String?> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_city');
  }
}