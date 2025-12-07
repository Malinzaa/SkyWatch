class RegionFilterModel {
  final String city;
  final String region;

  RegionFilterModel ({
    required this.city,
    required this.region
  });

  factory RegionFilterModel.fromJson (Map<String, dynamic> json) {
    return RegionFilterModel(
        city: json['city'],
        region: json['region'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city' : city,
      'region' : region,
    };
  }
}