class ForecastData {
  final int dt;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int weatherId;
  final String main;
  final String description;
  final String icon;
  final int cloudiness;
  final double windSpeed;
  final int windDeg;
  final String dtTxt;

  ForecastData({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.weatherId,
    required this.main,
    required this.description,
    required this.icon,
    required this.cloudiness,
    required this.windSpeed,
    required this.windDeg,
    required this.dtTxt,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    final mainJson = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weatherJson = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : {};
    final cloudsJson = json['clouds'] as Map<String, dynamic>? ?? {};
    final windJson = json['wind'] as Map<String, dynamic>? ?? {};

    return ForecastData(
      dt: json['dt'] as int? ?? 0,
      temp: (mainJson['temp'] as num?)?.toDouble() ?? 0,
      feelsLike: (mainJson['feels_like'] as num?)?.toDouble() ?? 0,
      tempMin: (mainJson['temp_min'] as num?)?.toDouble() ?? 0,
      tempMax: (mainJson['temp_max'] as num?)?.toDouble() ?? 0,
      pressure: mainJson['pressure'] as int? ?? 0,
      humidity: mainJson['humidity'] as int? ?? 0,
      weatherId: weatherJson['id'] as int? ?? 0,
      main: weatherJson['main'] as String? ?? '',
      description: weatherJson['description'] as String? ?? '',
      icon: weatherJson['icon'] as String? ?? '01d',
      cloudiness: cloudsJson['all'] as int? ?? 0,
      windSpeed: (windJson['speed'] as num?)?.toDouble() ?? 0,
      windDeg: windJson['deg'] as int? ?? 0,
      dtTxt: json['dt_txt'] as String? ?? '',
    );
  }
  
  double get tempCelsius => temp;
  double get tempMinCelsius => tempMin;
  double get tempMaxCelsius => tempMax;
  double get feelsLikeCelsius => feelsLike;

  // temperature in Fahrenheit
  double get tempFahrenheit => tempCelsius * 9 / 5 + 32;
  double get tempMinFahrenheit => tempMinCelsius * 9 / 5 + 32;
  double get tempMaxFahrenheit => tempMaxCelsius * 9 / 5 + 32;
  double get feelsLikeFahrenheit => feelsLikeCelsius * 9 / 5 + 32;

  String get tempC => tempCelsius.toInt().toString();
  String get tempF => tempFahrenheit.toInt().toString();
  String get tempMinC => tempMinCelsius.toInt().toString();
  String get tempMinF => tempMinFahrenheit.toInt().toString();
  String get tempMaxC => tempMaxCelsius.toInt().toString();
  String get tempMaxF => tempMaxFahrenheit.toInt().toString();
  String get feelsLikeC => feelsLikeCelsius.toInt().toString();
  String get feelsLikeF => feelsLikeFahrenheit.toInt().toString();
}