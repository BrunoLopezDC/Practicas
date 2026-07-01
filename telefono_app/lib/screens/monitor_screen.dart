import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/metric_card.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitor de Actividad'), centerTitle: true, actions: [
        Consumer<ActivityProvider>(
          builder: (ctx, ap, _) => IconButton(
            icon: Icon(ap.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled),
            color: ap.isConnected ? Colors.blue : Colors.grey,
            onPressed: () => ap.isConnected ? ap.disconnect() : ap.connect(),
          ),
        ),
      ]),
      body: Consumer<ActivityProvider>(
        builder: (context, ap, _) {
          if (ap.status == ConnectionStatus.scanning) return const Center(child: CircularProgressIndicator());
          if (ap.status == ConnectionStatus.error) return Center(child: Text(ap.errorMessage ?? 'Error'));
          if (!ap.isConnected) return const Center(child: Text('Conecta tu wearable'));
          
          final d = ap.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              if (d.heartRate > 120) 
                Container(padding: const EdgeInsets.all(12), color: Colors.red[50], child: Text('¡Ritmo cardiaco alto!', style: TextStyle(color: Colors.red))),
              GridView.count(
                shrinkWrap: true, crossAxisCount: 2, childAspectRatio: 1.1,
                children: [
                  MetricCard(label: 'PASOS', value: '${d.steps}', unit: 'pasos', color: Colors.green, icon: Icons.directions_walk),
                  MetricCard(label: 'RITMO', value: '${d.heartRate}', unit: 'bpm', color: d.heartRateColor, icon: Icons.favorite),
                  MetricCard(label: 'CALORÍAS', value: '${d.calories}', unit: 'kcal', color: Colors.orange, icon: Icons.local_fire_department),
                  MetricCard(label: 'ZONA', value: d.heartRateZone.split(' ').first, unit: '', color: Colors.purple, icon: Icons.speed),
                ],
              ),
            ]),
          );
        },
      ),
    );
  }
}