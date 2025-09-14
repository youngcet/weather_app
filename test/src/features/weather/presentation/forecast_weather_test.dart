import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_forecast.dart';
import 'package:provider/provider.dart';

class MockWeatherProvider extends Mock implements WeatherProvider {}

void main() {
  late MockWeatherProvider mockProvider;

  setUp(() {
    mockProvider = MockWeatherProvider();
  });

  testWidgets('displays loading state when forecast is null', (tester) async {
    when(() => mockProvider.city).thenReturn('London');
    when(() => mockProvider.dailyWeatherProvider).thenReturn([]);

    await tester.pumpWidget(
      ChangeNotifierProvider<WeatherProvider>.value(
        value: mockProvider,
        child: const MaterialApp(
          home: Scaffold(body: ForecastWeather()),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays forecast data correctly', (tester) async {
    final sampleForecast = [
      ForecastData(
        dt: 1757883600, 
        temp: 20,
        feelsLike: 19,
        tempMin: 18,
        tempMax: 21,
        pressure: 1010,
        humidity: 70,
        weatherId: 800,
        main: 'Clear',
        description: 'clear sky',
        icon: '01d',
        cloudiness: 1,
        windSpeed: 2.0,
        windDeg: 90,
        dtTxt: '2025-09-15 12:00:00',
      ),
    ];

    when(() => mockProvider.city).thenReturn('London');
    when(() => mockProvider.dailyWeatherProvider).thenReturn(sampleForecast);

    await tester.pumpWidget(
      ChangeNotifierProvider<WeatherProvider>.value(
        value: mockProvider,
        child: const MaterialApp(
          home: Scaffold(body: ForecastWeather()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final day = DateTime.fromMillisecondsSinceEpoch(sampleForecast[0].dt * 1000);
    final weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final expectedDay = weekdays[day.weekday - 1];

    expect(find.text(expectedDay), findsWidgets);
    expect(find.text('${sampleForecast[0].tempC}°'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
