import 'package:flutter/material.dart';
import '../model/regionfilter_model.dart';
import '../../../core/services/db_service.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class RegionFilterViewModel extends ChangeNotifier {
  List<RegionFilterModel> allCities = [];
  List<RegionFilterModel> filteredCities = [];
  String selectedRegion = 'All';
  bool isLoading = false;

  Future<void> loadCities() async {
    isLoading = true;
    notifyListeners();

    try {
      final String jsonString = await rootBundle.loadString('assets/data/regions.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<RegionFilterModel> loaded = <RegionFilterModel>[];
      data.forEach((String region, dynamic citiesList) {
        if (citiesList is List) {
          for (var c in citiesList) {
            if (c is String) {
              final RegionFilterModel item = RegionFilterModel(city: c, region: region);
              loaded.add(item);
            }
          }
        }
      });

      allCities = loaded;
      filteredCities = List<RegionFilterModel>.from(allCities);
      selectedRegion = 'All';
    } catch (e) {
      allCities = <RegionFilterModel>[];
      filteredCities = <RegionFilterModel>[];
    }

    isLoading = false;
    notifyListeners();
  }

  void setRegion(String region) {
    selectedRegion = region;

    if (region == 'All') {
      filteredCities = List<RegionFilterModel>.from(allCities);
    } else {
      filteredCities = allCities.where ((RegionFilterModel city) {
        return city.region == region;
      }).toList();
    }
    notifyListeners();
  }
}