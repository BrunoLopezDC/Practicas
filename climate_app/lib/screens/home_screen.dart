import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'package:climate_app/widgets/weather_icon.dart';
import 'package:climate_app/widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Clima Actual'), centerTitle: true),
      body: Center(
        child: width > 600
            ? _buildLandscapeLayout(context)
            : _buildPortraitLayout(context),
      ),
    );
  }
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '24°C',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Santiago de Querétaro', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 32),
        const WeatherIcon(condition: 'cloudy', size: 120),
        const SizedBox(height: 32),
        const Text('Humedad: 65% | Viento: 12 km/h'),
        const SizedBox(height: 40),
        PrimaryButton(
          text: 'Buscar Ciudades',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
      ],
    );
  }
  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '24°C',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text('Santiago de Querétaro', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Humedad: 65% | Viento: 12 km/h'),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WeatherIcon(condition: 'cloudy', size: 120),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Buscar Ciudades',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}