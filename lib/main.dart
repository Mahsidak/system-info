import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeviceInfoPage(),
    );
  }
}

class DeviceInfoPage extends StatefulWidget {
  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  static const platform = MethodChannel('com.system_info/device_info');
  Map<String, String> _deviceInfo = {};

  Future<void> getDeviceInfo() async {
    try {
      final Map result = await platform.invokeMethod('getDeviceInfo');
      setState(() {
        _deviceInfo = Map<String, String>.from(result);
      });
    } on PlatformException catch (e) {
      print("Failed to get device info: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
      ),
      body: _deviceInfo.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: _deviceInfo.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('${entry.key}: ${entry.value}'),
          );
        }).toList(),
      ),
    );
  }
}