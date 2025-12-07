class WeatherModel {
  final String cityName;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final double lat;
  final double lon;
  List<String> alerts;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.lat,
    required this.lon,
    this.alerts = const [],
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? "Unknown",
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? "No description",
      icon: json['weather'][0]['icon'],
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
      alerts: [],
    );
  }
}
