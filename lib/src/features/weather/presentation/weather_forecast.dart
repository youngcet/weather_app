import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_strings.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/forecast_data.dart';


import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:provider/provider.dart';

class ForecastWeather extends StatelessWidget {
  const ForecastWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider, (String city, List<ForecastData>?)>(
      selector: (context, provider) => (provider.city, provider.dailyWeatherProvider),
      builder: (context, data, _) {
        final forecast = data.$2;

        if (forecast!.isEmpty) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 10),
            ],
          );
        }

        // Show forecast data
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ForecastWeatherContents(data: forecast),
          ],
        );
      },
    );
  }
}

class ForecastWeatherContents extends StatelessWidget {
  const ForecastWeatherContents({super.key, required this.data});

  final List<ForecastData> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Builder(
        builder: (context) {
          // since the data from the api is in hourly (every 3 hours) 
          // but the assignment screenshot shows daily,
          // I am filtering by day as per the screenshot
          final dailyData = filterDailyForecasts(data);

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            itemCount: dailyData.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final forecast = dailyData[index];
              final day = DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000);
              final dayString = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][day.weekday - 1];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dayString, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  WeatherIconImage(
                    iconUrl: AppStrings.getWeatherIconUrl(forecast.icon), 
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text('${forecast.tempC}°',
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<ForecastData> filterDailyForecasts(List<ForecastData> forecasts) {
    Map<String, ForecastData> daily = {};

    for (final f in forecasts) {
      final date = DateTime.fromMillisecondsSinceEpoch(f.dt * 1000);
      final dayKey = "${date.year}-${date.month}-${date.day}";

      if (!daily.containsKey(dayKey) ||
          (date.hour - 12).abs() < (DateTime.fromMillisecondsSinceEpoch(daily[dayKey]!.dt * 1000).hour - 12).abs()) {
        daily[dayKey] = f;
      }
    }

    return daily.values.toList();
  }
}