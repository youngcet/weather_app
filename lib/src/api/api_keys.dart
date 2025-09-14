import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/constants/strings.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';

/// To get an API key, sign up here:
/// https://home.openweathermap.org/users/sign_up
///

final sl = GetIt.instance;

void setupInjection() {
  sl.registerLazySingleton<String>(() => AppStrings.openWeatherApiKey, instanceName: "api_key");
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<OpenWeatherMapAPI>(
    () => OpenWeatherMapAPI(sl<String>(instanceName: "api_key")),
  );

  sl.registerLazySingleton<HttpWeatherRepository>(
    () => HttpWeatherRepository(
      api: sl<OpenWeatherMapAPI>(),
      client: sl<http.Client>(),
    ),
  );
}
