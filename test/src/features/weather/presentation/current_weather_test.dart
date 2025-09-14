import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';

class MockWeatherProvider extends Mock implements WeatherProvider {}

void main() {
  late MockWeatherProvider mockProvider;

  setUp(() {
    mockProvider = MockWeatherProvider();
  });

  Widget makeTestableWidget(Widget child) {
    return ChangeNotifierProvider<WeatherProvider>.value(
      value: mockProvider,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('displays loading state when weather is null', (WidgetTester tester) async {
    when(() => mockProvider.city).thenReturn('London');
    when(() => mockProvider.currentWeatherProvider).thenReturn(null);
    when(() => mockProvider.error).thenReturn(null);

    await tester.pumpWidget(makeTestableWidget(const CurrentWeather()));

    expect(find.text('London'), findsOneWidget);
    expect(find.text('Fetching weather...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays error message when error is not null', (WidgetTester tester) async {
    when(() => mockProvider.city).thenReturn('London');
    when(() => mockProvider.currentWeatherProvider).thenReturn(null);
    when(() => mockProvider.error).thenReturn('City not found');

    await tester.pumpWidget(makeTestableWidget(const CurrentWeather()));

    expect(find.text('London'), findsOneWidget);
    expect(find.text('City not found'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('displays weather data when weather is available', (WidgetTester tester) async {
    when(() => mockProvider.city).thenReturn('London');
    when(() => mockProvider.error).thenReturn(null);

    final weatherData = WeatherData(
      temp: Temperature(25),
      minTemp: Temperature(20),
      maxTemp: Temperature(27),
      feelsLike: Temperature(24),
      pressure: 1012,
      humidity: 60,
      mainWeather: 'Clear',
      description: 'sunny',
      icon: '01d',
    );

    when(() => mockProvider.currentWeatherProvider).thenReturn(weatherData);

    await tester.pumpWidget(makeTestableWidget(const CurrentWeather()));

    expect(find.text('London'), findsOneWidget);
    expect(find.text('25°'), findsOneWidget);
    expect(find.text('H:27° L:20°'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
