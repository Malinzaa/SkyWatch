import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../view_model/forecast_view_model.dart';
import 'package:weather_forecast/main.dart';

class ForecastScreen extends StatefulWidget {
  final String city;

  ForecastScreen({required this.city});

  @override
  _ForecastScreenState createState() {
    return _ForecastScreenState();
  }
}

class _ForecastScreenState extends State<ForecastScreen> {
  late ForecastViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ForecastViewModel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchForecast(widget.city);
    });
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider.value (
      value: viewModel,
      child: Consumer<ForecastViewModel>(
          builder: (context, model, _) {
            return Scaffold(
                appBar: MyApp.customAppBar("Forecast - " + widget.city),
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: MyApp.globalBackgroundGradient,
                  child: Padding(
                      padding: EdgeInsets.all(w * 0.05),
                      child: model.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : model.errorMessage.isNotEmpty
                            ? Center(
                              child: Text(
                                model.errorMessage,
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                  color: Colors.red,
                                ),
                              ),
                            )
                            : Column(
                            children: [
                              if (model.dailyData.isNotEmpty)
                                SizedBox(
                                  height: h * 0.35,
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    tooltipBehavior: TooltipBehavior(enable: true),
                                    series: [
                                      LineSeries<Map<String, dynamic>, String> (
                                        dataSource: model.dailyData,
                                        xValueMapper: (data, index) {
                                          return data["date"];
                                        },
                                        yValueMapper: (data, index) {
                                          return data["avgTemp"];
                                        },
                                        markerSettings: MarkerSettings(isVisible: true),
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: h * 0.03),
                              Expanded(
                                  child: ListView.builder(
                                    itemCount: model.dailyData.length,
                                    itemBuilder: (context, index) {
                                      final day = model.dailyData[index];
                                      return Card(
                                        margin: EdgeInsets.only(bottom: h * 0.02),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(w * 0.04),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    day["date"],
                                                    style: TextStyle(
                                                      fontSize: w * 0.05,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: h * 0.01),
                                                  Text(
                                                    day["description"],
                                                    style: TextStyle(
                                                      fontSize: w * 0.045,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              Text(
                                                day["avgTemp"].toString() + "C",
                                                style: TextStyle(
                                                  fontSize: w * 0.06,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark? Colors.white70 : Color(0xFF693A12)
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                              )
                            ],
                          ),
                ),
              ),
            );
          },
      ),
    );
  }
}