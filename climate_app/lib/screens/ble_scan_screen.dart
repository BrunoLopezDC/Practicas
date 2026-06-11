import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ble_service.dart';
import '../providers/weather_provider.dart';

class BleScanScreen extends ConsumerStatefulWidget {
  const BleScanScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BleScanScreen> createState() => _BleScanScreenState();
}

class _BleScanScreenState extends ConsumerState<BleScanScreen> {
  final BLEService _bleService = BLEService();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _bleService.scanForDevices();
  }

  @override
  void dispose() {
    _bleService.stopScan();
    super.dispose();
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
    });

    try {
      await _bleService.stopScan();
      await _bleService.connect(device);
      
      await ref.read(weatherProvider.notifier).readFromWearable(device);
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isConnecting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos BLE')),
      body: _isConnecting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Conectando y leyendo datos...'),
                ],
              ),
            )
          : StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.scanResults,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Buscando dispositivos...'));
                }

                final results = snapshot.data!;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final device = results[index].device;
                    final deviceName = device.platformName.isNotEmpty 
                        ? device.platformName 
                        : 'Dispositivo Desconocido';

                    return ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: Text(deviceName),
                      subtitle: Text(device.remoteId.toString()),
                      onTap: () => _connectToDevice(device),
                    );
                  },
                );
              },
            ),
    );
  }
}