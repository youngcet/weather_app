import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/weather_data.dart';

class WeatherProvider extends ChangeNotifier {
  HttpWeatherRepository repository = HttpWeatherRepository(
    api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: http.Client(),
  );

  String city = 'London';
  WeatherData? currentWeatherProvider;
  // the screenshot shows days and not hours
  // therefore, renaming this variable and 
  // making it a list instead of a single data point
  // ForecastData? hourlyWeatherProvider; 
  // the getForecastData() function has also been updated to match this
  List<ForecastData> dailyWeatherProvider = []; 

  // a new variable to show errors
  String? error;

  Future<void> getWeatherData() async {
    try{
      final weather = await repository.getWeather(city: city);
      currentWeatherProvider = weather;
      notifyListeners();

      // get forecast data
      await getForecastData();
    }catch (e){
      error = e.toString();
       throw Exception(e);
    }
  }

  Future<void> getForecastData() async {
    try {
      final forecasts = await repository.getForecast(city: city);
      dailyWeatherProvider = forecasts; 
      notifyListeners();
    } catch (e) {
      error = e.toString();
      throw Exception(e);
    }
  }
}
