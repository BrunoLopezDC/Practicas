class WeatherUtils {
  static double celsiusToFahrenheit(int celsius) {
    return (celsius * 9 / 5) + 32;
  }

  static int fahrenheitToCelsius(double fahrenheit) {
    return ((fahrenheit - 32) * 5 / 9).toInt();
  }

  static String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return 'Soleado';
      case 'cloudy':
        return 'Nublado';
      case 'rainy':
        return 'Lluvioso';
      case 'snowy':
        return 'Nevado';
      default:
        return 'Desconocido';
    }
  }

  static bool isValidTemperature(int temp) {
    return temp >= -50 && temp <= 60;
  }
}