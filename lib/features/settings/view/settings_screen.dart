import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/settings_view_model.dart';
import 'package:weather_forecast/main.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen ({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build (BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    SettingsViewModel model = Provider.of<SettingsViewModel>(context);

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color sectionTitleColor = Colors.black;
    Color unselectedButtonBg = isDark ? Colors.black : Colors.white;
    Color unselectedButtonText = isDark ? Colors.white : Colors.black;
    Color selectedButtonBg = const Color(0xFF5EB9BF);
    Color selectedButtonText = isDark? Colors.black : Colors.white;


    return Scaffold(
      appBar: MyApp.customAppBar("Settings"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: MyApp.globalBackgroundGradient,
        padding: EdgeInsets.all(w * 0.05),
        child: Column(
          children: [
            //temp unit
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Temperature Unit",
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                  color: sectionTitleColor,
                ),
              ),
            ),
            SizedBox(height: h * 0.01),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        model.setTempUnit('C');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: h * 0.015),
                        decoration: BoxDecoration(
                          color: (model.tempUnit == 'C') ? selectedButtonBg : unselectedButtonBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            "Celcius (C)",
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w600,
                              color: (model.tempUnit == 'C') ? selectedButtonText : unselectedButtonText,
                            ),
                          ),
                        ),
                      ),
                    ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        model.setTempUnit('F');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: h * 0.015),
                        decoration: BoxDecoration(
                          color: (model.tempUnit == 'F') ? selectedButtonBg : unselectedButtonBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            "Fahrenheit (F)",
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w600,
                              color: (model.tempUnit == 'F') ? selectedButtonText : unselectedButtonText,
                            ),
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: h * 0.03),

            //wind unit
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Wind Speed Unit",
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                  color: sectionTitleColor,
                ),
              ),
            ),
            SizedBox(height: h * 0.01),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      model.setWindUnit('m/s');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: h * 0.015),
                      decoration: BoxDecoration(
                        color: (model.windUnit == 'm/s') ? selectedButtonBg : unselectedButtonBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          "m/s",
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w600,
                            color: (model.windUnit == 'm/s') ? selectedButtonText : unselectedButtonText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        model.setWindUnit('km/h');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: h * 0.015),
                        decoration: BoxDecoration(
                          color: (model.windUnit == 'km/h') ? selectedButtonBg : unselectedButtonBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            "km/h",
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w600,
                              color: (model.windUnit == 'km/h') ? selectedButtonText : unselectedButtonText,
                            ),
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: h * 0.03),

            //Theme mode
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Theme",
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                  color: sectionTitleColor,
                ),
              ),
            ),
            SizedBox(height: h * 0.01),
            Column(
              children: [
                RadioListTile<String>(
                  value: 'system',
                  groupValue: model.themeMode,
                  onChanged: (String? value) {
                    if (value != null) {
                      model.setThemeMode(value);
                    }
                  },
                  title: Text(
                    "System Default",
                    style: TextStyle(color: sectionTitleColor),
                  ),
                ),
                RadioListTile<String>(
                  value: 'light',
                  groupValue: model.themeMode,
                  onChanged: (String? value) {
                    if (value != null) {
                      model.setThemeMode(value);
                    }
                  },
                  title: Text(
                    "Light",
                    style: TextStyle(color: sectionTitleColor),
                  ),
                ),
                RadioListTile<String>(
                  value: 'dark',
                  groupValue: model.themeMode,
                  onChanged: (String? value) {
                    if (value != null) {
                      model.setThemeMode(value);
                    }
                  },
                  title: Text(
                    "Dark",
                    style: TextStyle(color: sectionTitleColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.03),

            //alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weather Alerts",
                  style: TextStyle(
                    fontSize: w * 0.04,
                    color: sectionTitleColor,
                  ),
                ),
                Switch(
                    value: model.notificationsEnabled,
                    onChanged: (bool value) {
                      model.setNotificationsEnabled(value);
                    },
                ),
              ],
            ),
            SizedBox(height: h * 0.03),
          ],
        ),
      ),
    );
  }
}