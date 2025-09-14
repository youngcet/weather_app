class AppStrings{
  static const openWeatherApiKey = 'c329bcceca82fba38455509439519693';
  static const weatherIconUrl = 'https://openweathermap.org/img/wn/{icon}@2x.png';

  static String getWeatherIconUrl(String icon) {
    return weatherIconUrl.replaceAll('{icon}', icon);
  }
}