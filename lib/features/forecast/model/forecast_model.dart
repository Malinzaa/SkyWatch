class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;

  ForecastModel ({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory ForecastModel.fromJson (Map<String, dynamic> json) {
    return ForecastModel(
        dateTime: DateTime.parse(json['dt_txt']),
        temperature: (json['main']['temp'] as num).toDouble(),
        description: (json['weather'] != null && json['weather'].isNotEmpty)
              ? json['weather'][0]['description']
              : "No Description",
        icon: (json['weather'] != null && json['weather'].isNotEmpty)
              ? json['weather'][0]['icon']
              : "",
    );
  }
}