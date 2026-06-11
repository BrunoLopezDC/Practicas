import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  Stream<List<ScanResult>> scanForDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    return FlutterBluePlus.scanResults;
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<void> connect(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  Future<Map<String, dynamic>?> readWeatherCharacteristic(
      BluetoothDevice device, String serviceUuid, String characteristicUuid) async {
    
    try {
      List<BluetoothService> services = await device.discoverServices();
      
      Guid targetServiceGuid = Guid(serviceUuid);
      Guid targetCharacteristicGuid = Guid(characteristicUuid);

      for (BluetoothService service in services) {
        if (service.uuid == targetServiceGuid) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == targetCharacteristicGuid) {
              
              List<int> value = await characteristic.read().timeout(const Duration(seconds: 5));
              String jsonString = utf8.decode(value, allowMalformed: true).trim().replaceAll('\x00', '');
              
              Map<String, dynamic> data = jsonDecode(jsonString);
              return _validateSecurityCriteria(data); 
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Map<String, dynamic>? _validateSecurityCriteria(Map<String, dynamic> data) {
    if (!data.containsKey('city') || !data.containsKey('temp')) {
      return null;
    }

    String city = data['city'].toString();
    double temp = double.tryParse(data['temp'].toString()) ?? 0.0;

    if (city.length >= 50) {
      throw const FormatException('Violación de seguridad: La ciudad excede los 50 caracteres.');
    }
   
    if (temp < -60 || temp > 60) {
      throw const FormatException('Violación de seguridad: Temperatura fuera de rango (-60 a 60).');
    }

    return data;
  }
}