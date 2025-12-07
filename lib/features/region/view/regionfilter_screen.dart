import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/main.dart';
import 'package:weather_forecast/features/region/model/regionfilter_model.dart';
import '../view_model/regionfilter_view_model.dart';

class RegionFilterScreen extends StatefulWidget {
  final Function(String)? onSelect;
  const RegionFilterScreen ({Key? key, this.onSelect}) : super(key: key);

  @override
  _RegionFilterScreenState createState() {
    return _RegionFilterScreenState();
  }
}

class _RegionFilterScreenState extends State<RegionFilterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RegionFilterViewModel>(context, listen: false).loadCities();
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
            child: Consumer<RegionFilterViewModel>(
                builder: (context, model, child) {
                  if ( model.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<String> regions = ['All'];
                  for (var city in model.allCities) {
                    if (!regions.contains(city.region)) {
                      regions.add(city.region);
                    }
                  }

                  return Padding(
                    padding: EdgeInsets.all(w * 0.05),
                    child: Column(
                      children: [
                        DropdownButton<String>(
                            value: model.selectedRegion,
                            items: regions.map((region) {
                              return DropdownMenuItem<String>(
                                value: region,
                                child: Text(
                                  region,
                                  style: TextStyle(
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.brown
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                model.setRegion(value);
                              }
                            },
                        ),
                        SizedBox(height: h * 0.02),
                        Expanded(
                            child: model.filteredCities.isEmpty
                                ? Center(
                                  child: Text("No cities in this region"),
                                )
                                :ListView.builder(
                                  itemCount: model.filteredCities.length,
                                  itemBuilder: (context, index) {
                                    RegionFilterModel city = model.filteredCities[index];

                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: w * 0.01),
                                        child: Container(
                                          height: h * 0.08,
                                          padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                                          alignment: Alignment.center,
                                          child: ListTile(
                                            title: Text(
                                              city.city,
                                              style: TextStyle(
                                                fontSize: w * 0.05,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            subtitle: Text(
                                              city.region,
                                              style: TextStyle(
                                                fontSize: w * 0.04,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onTap: () {
                                              if (widget.onSelect != null) {
                                                widget.onSelect!(city.city);
                                              }
                                            },
                                          ),
                                        ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
            ),
        ),
    );
  }
}