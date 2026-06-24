import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/ble_service.dart';

class WeatherState {
  final bool isLoading;
  final String? errorMessage;
  final Weather? weather;
  final int tempUnit; 

  WeatherState({
    this.isLoading = false,
    this.errorMessage,
    this.weather,
    this.tempUnit = 0,
  });

  String get temperatureUnitString => tempUnit == 0 ? '°C' : '°F';

  WeatherState copyWith({
    bool? isLoading,
    String? errorMessage,
    Weather? weather,
    int? tempUnit,
    bool clearError = false,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      weather: weather ?? this.weather,
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(WeatherState());
  
  final WeatherService _weatherService = WeatherService();
  final BLEService _bleService = BLEService();

  void toggleTemperatureUnit() {
    state = state.copyWith(tempUnit: state.tempUnit == 0 ? 1 : 0);
  }

  Future<void> loadWeather(String city) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final weather = await _weatherService.getWeather(city);
      state = state.copyWith(isLoading: false, weather: weather);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> readFromWearable(BluetoothDevice device) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _bleService.readWeatherCharacteristic(device, '181a', '2a6e');
      
      if (data != null) {
        final weather = Weather(
          city: data['city'].toString(),
          temperature: int.tryParse(data['temp'].toString()) ?? 0,
          condition: 'BLE',
          description: 'Sensor Wearable',
          humidity: 0,
          windSpeed: 0.0,
        );
        state = state.copyWith(isLoading: false, weather: weather);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Datos BLE inválidos o incompletos');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error en BLE: $e',
      );
    }
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier();
});