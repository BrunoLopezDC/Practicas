import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'search_screen.dart';
import 'ble_scan_screen.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_icon.dart';
import '../widgets/primary_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weatherProvider);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final selectedCity = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
              if (selectedCity != null) {
                ref.read(weatherProvider.notifier).loadWeather(selectedCity);
              }
            },
          )
        ],
      ),
      body: _buildBody(state, ref, width, context),
    );
  }

  Widget _buildBody(WeatherState state, WidgetRef ref, double width, BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Buscar dispositivos BLE',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BleScanScreen()),
              ),
            ),
          ],
        ),
      );
    }
    
    if (state.weather == null) {
      return const Center(child: Text('Sin datos'));
    }

    return Center(
      child: width > 600
          ? _buildLandscapeLayout(state, ref, context)
          : _buildPortraitLayout(state, ref, context),
    );
  }

  Widget _buildPortraitLayout(WeatherState state, WidgetRef ref, BuildContext context) {
    final weather = state.weather!;
    final displayTemp = state.tempUnit == 0 
        ? weather.temperature 
        : WeatherUtils.celsiusToFahrenheit(weather.temperature).toInt();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$displayTemp${state.temperatureUnitString}',
            style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(weather.city, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 32),
          WeatherIcon(condition: weather.condition, size: 120),
          const SizedBox(height: 32),
          Text('Humedad: ${weather.humidity}%'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(weatherProvider.notifier).toggleTemperatureUnit(),
            child: const Text('Cambiar unidad'),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Buscar dispositivos BLE',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BleScanScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(WeatherState state, WidgetRef ref, BuildContext context) {
    final weather = state.weather!;
    final displayTemp = state.tempUnit == 0 
        ? weather.temperature 
        : WeatherUtils.celsiusToFahrenheit(weather.temperature).toInt();

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$displayTemp${state.temperatureUnitString}',
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              Text(weather.city, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              Text('Humedad: ${weather.humidity}%'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(weatherProvider.notifier).toggleTemperatureUnit(),
                child: const Text('Cambiar unidad'),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WeatherIcon(condition: weather.condition, size: 100),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Buscar dispositivos BLE',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BleScanScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}