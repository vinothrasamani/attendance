import 'dart:convert';

import 'package:attendance/model/school_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class WifiService with WidgetsBindingObserver {
  static const platform = MethodChannel("wifi_channel");

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final school = preferences.getString('school');
      if (school != null) {
        final data = SchoolData.fromJson(jsonDecode(school));
        await connectToWifi(data.username, data.password);
      }
    } else if (state == AppLifecycleState.detached) {
      await WiFiForIoTPlugin.disconnect();
    } else if (state == AppLifecycleState.paused) {
      Future.delayed(const Duration(seconds: 20), () async {
        final isForeground =
            WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
        if (!isForeground) {
          await WiFiForIoTPlugin.disconnect();
        }
      });
    }
  }

  static Future<void> requestPermissions() async {
    final p = await Permission.location.isGranted;
    if (!p) {
      await Permission.location.request();
    }
    if (await Permission.location.isDenied) {
      Get.snackbar(
        'Alert!',
        'Location permission is required to connect wifi with you.',
        borderRadius: 5,
        backgroundColor: const Color.fromARGB(255, 216, 184, 0),
        colorText: Colors.white,
      );
    }
  }

  static Future checkLocationStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
  }

  static Future<bool> connectToWifi(String ssid, String password) async {
    ssid = ssid.trim();
    password = password.trim();

    if (ssid.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Configuration Error',
        'WiFi credentials are not properly configured.',
        borderRadius: 5,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      final currentSSID = await WiFiForIoTPlugin.getSSID();
      if (currentSSID != null && currentSSID.contains(ssid)) {
        await bindToWifi();
        return true;
      }

      // ignore: deprecated_member_use
      List<WifiNetwork?>? networks = await WiFiForIoTPlugin.loadWifiList();
      final exists = networks.any((net) => net?.ssid == ssid);
      if (exists) {
        bool isConnected = await WiFiForIoTPlugin.connect(ssid,
            password: password, joinOnce: true, security: NetworkSecurity.WPA);
        if (isConnected) {
          await bindToWifi();
          await Future.delayed(Duration(seconds: 2));
          return true;
        } else {
          Get.snackbar(
            'WiFi Connection Failed',
            'Could not connect to $ssid. Please check credentials.',
            borderRadius: 5,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'WiFi Not Found',
          'Network $ssid is not available. Please ensure you\'re in range and active location.',
          borderRadius: 5,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Connection Error',
        'Failed to connect to WiFi network.',
        borderRadius: 5,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  static Future<bool> bindToWifi() async {
    try {
      await platform.invokeMethod("bindNetwork");
      debugPrint("Successfully bound app to Wi-Fi network");
      return true;
    } catch (e) {
      debugPrint("Failed to bind network: $e");
      return false;
    }
  }
}
