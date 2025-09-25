import 'dart:convert';

import 'package:attendance/model/school_model.dart';
import 'package:attendance/model/user_model.dart';
import 'package:attendance/view/home_screen.dart';
import 'package:attendance/view_model/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth_android/local_auth_android.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance/base_file.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final isLoading = StateProvider<bool>((ref) => false);
  static final canSelectSchool = StateProvider<bool>((ref) => false);
  static final schoolList = StateProvider<List<SchoolData>>((ref) => []);

  static Future<void> checkSelectionStatus(WidgetRef ref) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final school = preferences.getString('school');
    if (school == null) {
      ref.read(canSelectSchool.notifier).state = true;
    } else {
      final data = SchoolData.fromJson(jsonDecode(school));
      ref.read(BaseFile.ip.notifier).state = data.ip;
      ref.read(BaseFile.port.notifier).state = data.port;
      ref.read(BaseFile.username.notifier).state = data.username;
      ref.read(BaseFile.password.notifier).state = data.password;
    }
  }

  static Future<void> saveSchool(SchoolData sd) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('school', jsonEncode(sd));
  }

  static Future<void> loadSchools(WidgetRef ref) async {
    final url = Uri.parse('${BaseFile.baseNetworkUrl}/schools');
    final res = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    if (res.statusCode == 200) {
      final data = schoolModelFromJson(res.body);
      if (data.success) {
        ref.read(schoolList.notifier).state = data.data;
      }
    }
  }

  static Future<bool> isBiomatricSupported() async {
    return await LocalAuthPlatform.instance.isDeviceSupported();
  }

  static Future<bool> checkBiometrics() async {
    late bool supportsBiometrics;
    try {
      supportsBiometrics =
          await LocalAuthPlatform.instance.deviceSupportsBiometrics();
    } on PlatformException catch (e) {
      supportsBiometrics = false;
      debugPrint(e.toString());
    }
    return supportsBiometrics;
  }

  static Future<void> authendicate() async {
    try {
      final isAuthendicated = await LocalAuthPlatform.instance.authenticate(
        localizedReason: 'Easy login with biometrics',
        authMessages: <AuthMessages>[
          AndroidAuthMessages(),
        ],
        options: AuthenticationOptions(stickyAuth: true),
      );
      if (isAuthendicated) {
        Get.off(
          () => HomeScreen(),
          transition: Transition.fade,
          duration: Duration(milliseconds: 500),
        );
      } else {
        Get.snackbar(
          'Failed!',
          'Authendication failed or canceled by the user!',
          borderRadius: 5,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void submit(WidgetRef ref, Object object) async {
    final ip = ref.read(BaseFile.ip);
    final port = ref.read(BaseFile.port);
    final done = await HomeService.isServerReachable(ip, port);
    if (!done) {
      Get.snackbar(
        'Network Unavailable!',
        'Please connect with an appropriate network.',
        borderRadius: 5,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final res = await BaseFile.postMethod('login', object, ip, port);
    final data = userModelFromJson(res);
    if (data.success) {
      preferences.setString('user', jsonEncode(data.data));
      Get.offAll(() => HomeScreen());
      Get.snackbar(
        'Logged In',
        'User logged in successfully!',
        borderRadius: 5,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Failed',
        data.message,
        borderRadius: 5,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    ref.read(isLoading.notifier).state = false;
  }
}
