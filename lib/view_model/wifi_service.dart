import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      debugPrint('Connection terminated');
      // WiFiForIoTPlugin.disconnect();
    } else if (state == AppLifecycleState.resumed) {
      // WifiService.connectToWifi('Airtel_jega_8033', 'air12347');
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

  static Future<void> connectToWifi(String ssid, String password) async {
    ssid = ssid.trim();
    password = password.trim();
    try {
      // ignore: deprecated_member_use
      List<WifiNetwork?>? networks = await WiFiForIoTPlugin.loadWifiList();
      final exists = networks.any((net) => net?.ssid == ssid);

      if (exists) {
        bool isConnected = await WiFiForIoTPlugin.connect(ssid,
            password: password, joinOnce: true, security: NetworkSecurity.WPA);
        if (isConnected) {
          debugPrint("Connected to $ssid");
        } else {
          debugPrint("Failed to connect");
        }
      } else {
        debugPrint("Wi-Fi $ssid not found");
      }
      await bindToWifi();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> bindToWifi() async {
    try {
      await platform.invokeMethod("bindNetwork");
      debugPrint("Bound app to Wi-Fi network");
    } catch (e) {
      debugPrint("Failed to bind network: $e");
    }
  }
}
