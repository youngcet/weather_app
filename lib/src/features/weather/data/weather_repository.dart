import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/weather_data.dart';

class HttpWeatherRepository {
  final OpenWeatherMapAPI api;
  final http.Client client;

  HttpWeatherRepository({
    required this.api,
    required this.client,
  });

  Future<WeatherData> getWeather({required String city}) async {
    final url = api.weather(city);
    final response = await client.get(Uri.parse('$url'));

    Map<String, dynamic> json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json);
    } else {
      throw Exception("Failed to fetch weather: ${json['message']}");
    }
  }

  Future<List<ForecastData>> getForecast({required String city}) async {
    final url = api.forecast(city);
    final response = await client.get(Uri.parse('$url'));

    final Map<String, dynamic> json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final list = json['list'] as List<dynamic>? ?? [];

      return list
          .map((item) => ForecastData.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch forecast: ${json['message']}");
    }
  }
}