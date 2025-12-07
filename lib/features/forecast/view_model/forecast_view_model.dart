import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../model/forecast_model.dart';

class ForecastViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String errorMessage = "";
  List<ForecastModel> rawList = <ForecastModel>[];
  List<Map<String, dynamic>> dailyData = <Map<String, dynamic>>[];

  Future<void> fetchForecast (String city) async {
    isLoading = true;
    errorMessage = "";
    rawList = <ForecastModel>[];
    dailyData = <Map<String, dynamic>>[];
    notifyListeners();

    try {
      final response = await _apiService.getForecast(city);
      final List<dynamic> list = response.data['list'] as List<dynamic>;
      rawList = list.map((item) {
        return ForecastModel.fromJson(item as Map<String, dynamic>);
      }).toList();

      final Map<String, List<ForecastModel>> groups = <String, List<ForecastModel>>{};
      for (var item in rawList) {
        String dateKey = item.dateTime.toIso8601String().substring(0,10);
        if (!groups.containsKey(dateKey)) {
          groups [dateKey] = <ForecastModel>[];
        }
        groups[dateKey]!.add(item);
      }

      final List<Map<String, dynamic>> tempDaily = <Map<String, dynamic>>[];
      groups.forEach((key, value) {
        double sum = 0.0;
        for (var it in value) {
          sum = sum + it.temperature;
        }
        double avg = 0.0;
        if (value.isNotEmpty) {
          avg = sum/value.length;
        }

        final ForecastModel representative = value[value.length ~/ 2];
        tempDaily.add({
          'date' : key,
          'avgTemp' : double.parse(avg.toStringAsFixed(1)),
          'description' : representative.description,
          'icon' : representative.icon,
        });
      });

      tempDaily.sort((a, b) {
        return a['date'].compareTo(b['date']);
      });
      if (tempDaily.length > 5) {
        dailyData = tempDaily.sublist(0, 5);
      } else {
        dailyData = tempDaily;
      }
      print("Forecast dailyData: " + dailyData.toString());
    } catch (e) {
      print ("Error fetching forecast: " + e.toString());
      errorMessage = "Could not load forecast for " + city;
      rawList = <ForecastModel>[];
      dailyData = <Map<String, dynamic>>[];
    }finally {
      isLoading = false;
      notifyListeners();
    }
  }
}