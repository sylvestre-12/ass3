import 'dart:async';
import 'package:battery/battery.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  final Battery _battery = Battery();
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    initBattery();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      Fluttertoast.showToast(msg: 'Internet Connected!');
    } else {
      Fluttertoast.showToast(msg: 'No Internet Connection!');
    }
  }

  Future<void> initBattery() async {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (state == BatteryState.charging) {
        _battery.batteryLevel.then((level) {
          if (level >= 50) {
            Fluttertoast.showToast(msg: 'Battery level is now $level%');
            // Add your ringtone code here
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: themeMode == ThemeMode.light
          ? ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      )
          : ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: HomeScreen(
        onThemeChanged: (themeMode) {
          setState(() {
            this.themeMode = themeMode;
          });
        },
      ),
    );
  }
}