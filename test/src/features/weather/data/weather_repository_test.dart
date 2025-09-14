import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';

class MockHttpClient extends Mock implements http.Client {}
class UriFake extends Fake implements Uri {}

class MockAPI extends OpenWeatherMapAPI {
  MockAPI() : super('dummyApiKey');
}

const encodedWeatherJsonResponse = """
{
  "main": {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  },
  "weather": [
    {
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ]
}
""";

const encodedForecastJsonResponse = """
{
  "list": [
    {
      "dt": 1757883600,
      "main": {"temp": 17.6, "feels_like": 17.7, "temp_min": 16.6, "temp_max": 18.0, "humidity": 70}
    },
    {
      "dt": 1757969999,
      "main": {"temp": 18.0, "feels_like": 18.2, "temp_min": 17.0, "temp_max": 19.0, "humidity": 65}
    }
  ]
}
""";

void main() {
  setUpAll(() {
    registerFallbackValue(UriFake());
  });

  late MockHttpClient mockHttpClient;
  late MockAPI api;
  late HttpWeatherRepository weatherRepository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    api = MockAPI();
    weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);
  });

  test('getWeather returns WeatherData when HTTP 200', () async {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response(encodedWeatherJsonResponse, 200),
    );

    final weather = await weatherRepository.getWeather(city: 'London');

    expect(weather.temp.celsius, 282.55);
    expect(weather.minTemp.celsius, 280.37);
    expect(weather.maxTemp.celsius, 284.26);
    expect(weather.feelsLike.celsius, 281.86);
    expect(weather.humidity, 100);
    expect(weather.pressure, 1023);
    expect(weather.mainWeather, 'Clear');
    expect(weather.description, 'clear sky');
    expect(weather.icon, '01d');
  });


  test('getWeather throws CityNotFoundException when HTTP 404', () async {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response('{"message":"city not found"}', 404),
    );

    expect(
      () async => await weatherRepository.getWeather(city: 'UnknownCity'),
      throwsA(isA<CityNotFoundException>()),
    );
  });

  test('getForecast returns List<ForecastData> when HTTP 200', () async {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response(encodedForecastJsonResponse, 200),
    );

    final forecast = await weatherRepository.getForecast(city: 'London');

    expect(forecast, isA<List<ForecastData>>());
    expect(forecast.length, 2);

    final first = forecast[0];
    expect(first.tempCelsius, 17.6);
    expect(first.feelsLikeCelsius, 17.7);
    expect(first.tempMinCelsius, 16.6);
    expect(first.tempMaxCelsius, 18.0);
    expect(first.humidity, 70);

    final second = forecast[1];
    expect(second.tempCelsius, 18.0);
    expect(second.feelsLikeCelsius, 18.2);
    expect(second.tempMinCelsius, 17.0);
    expect(second.tempMaxCelsius, 19.0);
    expect(second.humidity, 65);
  });

  test('getForecast throws InvalidApiKeyException when HTTP 401', () async {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response('{"message":"invalid api key"}', 401),
    );

    expect(
      () async => await weatherRepository.getForecast(city: 'London'),
      throwsA(isA<InvalidApiKeyException>()),
    );
  });

  test('getForecast throws UnknownException when HTTP 500', () async {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response('{"message":"server error"}', 500),
    );

    expect(
      () async => await weatherRepository.getForecast(city: 'London'),
      throwsA(isA<UnknownException>()),
    );
  });
}
