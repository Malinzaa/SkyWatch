import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = "https://api.openweathermap.org/data/2.5";
  final String apiKey = "5e38ecef162d634b63557a6b9b2e404c";

  Future<Response> getCurrentWeather (String city) async {
    try {
      return await _dio.get(
        "$baseUrl/weather",
        queryParameters: {
          "q" : city,
          "appid" : apiKey,
          "units" : "metric"
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWeatherAlerts(double lat, double lon) async {
    final apiKey = "5e38ecef162d634b63557a6b9b2e404c";
    final url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=current,minutely,hourly,daily&appid=$apiKey";

    final response = await Dio().get(url);
    return response.data;
  }


  Future<Response> getForecast (String city) async {
    try {
      return await _dio.get(
        "$baseUrl/forecast",
        queryParameters: {
          "q" : city,
          "appid" : apiKey,
          "units" : "metric"
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}