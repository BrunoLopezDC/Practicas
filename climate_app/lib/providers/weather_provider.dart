import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';

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
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier();
});