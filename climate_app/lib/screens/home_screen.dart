import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import 'ble_scan_screen.dart'; 

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(weatherProvider.notifier).loadWeather('Queretaro'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      ref.read(weatherProvider.notifier).loadWeather(city);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Buscar ciudad...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(WeatherState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(weatherProvider.notifier).loadWeather('Queretaro'),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.weather == null) {
      return const Center(child: Text('Ingresa una ciudad'));
    }

    final w = state.weather!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(w.city, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('${w.temperature}°C',
              style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          Text(w.description, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('Humedad', '${w.humidity}%'),
              _stat('Viento', '${w.windSpeed} m/s'),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.bluetooth),
            label: const Text('Buscar sensor BLE'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BleScanScreen()),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      );
}