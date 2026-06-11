import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/weather.dart';
import '../services/ble_service.dart';

class WeatherState {
  final Weather? weather;
  final bool isLoading;
  final String? errorMessage;
  final int tempUnit;

  WeatherState({
    this.weather,
    this.isLoading = false,
    this.errorMessage,
    this.tempUnit = 0,
  });

  WeatherState copyWith({
    Weather? weather,
    bool? isLoading,
    String? errorMessage,
    int? tempUnit,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }

  String get temperatureUnitString => tempUnit == 0 ? '°C' : 'F';
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final BLEService _bleService = BLEService();

  WeatherNotifier() : super(WeatherState()) {
    loadWeather('Santiago de Querétaro');
  }

  Future<void> loadWeather(String city) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(seconds: 1));
      final newWeather = Weather(
        city: city,
        temperature: 24,
        condition: 'cloudy',
        humidity: 65,
      );
      state = state.copyWith(isLoading: false, weather: newWeather);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error: $e');
    }
  }

  void toggleTemperatureUnit() {
    state = state.copyWith(tempUnit: state.tempUnit == 0 ? 1 : 0);
  }

  Future<void> readFromWearable(BluetoothDevice device) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final data = await _bleService.readWeatherCharacteristic(
        device,
        "0000181a-0000-1000-8000-00805f9b34fb", 
        "00002a6e-0000-1000-8000-00805f9b34fb",
      );

      if (data != null) {
        final newWeather = Weather(
          city: data['city'].toString(),
          temperature: double.parse(data['temp'].toString()).toInt(),
          condition: data['condition']?.toString() ?? 'cloudy',
          humidity: int.tryParse(data['humidity']?.toString() ?? '0') ?? 0,
        );
        state = state.copyWith(isLoading: false, weather: newWeather);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: 'Datos BLE inválidos o incompletos');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error leyendo wearable: $e');
    }
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier();
});