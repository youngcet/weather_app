import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/constants/strings.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/models/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:provider/provider.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider, (String city, WeatherData?, String? error)>(
      selector: (context, provider) => (provider.city, provider.currentWeatherProvider, provider.error),
      builder: (context, data, _) {
        final city = data.$1;
        final weather = data.$2;
        final error = data.$3;

        // display errors
        if (error != null){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(city, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(
                error,
                style: const TextStyle(color: AppColors.red),
              ),
            ],
          );
        }

        if (weather == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(city, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Text("Fetching weather..."),
            ],
          );
        }

        // Show weather data
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(city, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            CurrentWeatherContents(data: weather),
          ],
        );
      },
    );
  }
}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents({super.key, required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temp.celsius.toInt().toString();
    final minTemp = data.minTemp.celsius.toInt().toString();
    final maxTemp = data.maxTemp.celsius.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: AppStrings.getWeatherIconUrl(data.icon), size: 120),
        const SizedBox(height: 8),
        Text('$temp°', style: textTheme.displayMedium),
        const SizedBox(height: 4),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }
}