class Temperature {
  final double value; // in Celsius

  Temperature(this.value);

  double get celsius => value;

  /// Convert to Fahrenheit (optional)
  double get fahrenheit => value * 9 / 5 + 32;
}

class WeatherData {
  final Temperature temp;
  final Temperature minTemp;
  final Temperature maxTemp;
  final Temperature feelsLike;
  final int pressure;
  final int humidity;
  final int? seaLevel;
  final int? grndLevel;

  final String mainWeather;
  final String description;
  final String icon;

  WeatherData({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    this.seaLevel,
    this.grndLevel,
    required this.mainWeather,
    required this.description,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final mainJson = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList.first as Map<String, dynamic> : {};

    return WeatherData(
      temp: Temperature((mainJson['temp'] as num?)?.toDouble() ?? 0),
      minTemp: Temperature((mainJson['temp_min'] as num?)?.toDouble() ?? 0),
      maxTemp: Temperature((mainJson['temp_max'] as num?)?.toDouble() ?? 0),
      feelsLike: Temperature((mainJson['feels_like'] as num?)?.toDouble() ?? 0),
      pressure: mainJson['pressure'] as int? ?? 0,
      humidity: mainJson['humidity'] as int? ?? 0,
      seaLevel: mainJson['sea_level'] as int?,
      grndLevel: mainJson['grnd_level'] as int?,
      mainWeather: weather['main'] as String? ?? '',
      description: weather['description'] as String? ?? '',
      icon: weather['icon'] as String? ?? '01d',
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}