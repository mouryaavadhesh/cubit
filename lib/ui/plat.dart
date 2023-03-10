import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel extends StatefulWidget {
  const PlatformChannel({super.key});

  @override
  State<PlatformChannel> createState() => _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  static const MethodChannel methodChannel =
  MethodChannel('samples.flutter.io/battery');
  static const EventChannel eventChannel =
  EventChannel('samples.flutter.io/charging');
  String _batteryLevel = 'Battery level: unknown.';
  String _chargingStatus = 'Battery status: unknown.';


  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int? result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result%.';
    } on PlatformException catch (e) {
      if (e.code == 'NO_BATTERY') {
        batteryLevel = 'No battery.';
      } else {
        batteryLevel = 'Failed to get battery level.';
      }
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }




  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object? event) {
    setState(() {
      _chargingStatus =
      "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = 'Battery status: unknown.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery level '),),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(_batteryLevel, key: const Key('Battery level label')),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('Refresh'),
              ),
            ),
            Text(_chargingStatus),
          ],
        ),
      ),
    );
  }
}