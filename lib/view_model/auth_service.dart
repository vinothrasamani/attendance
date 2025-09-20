import 'dart:convert';

import 'package:attendance/model/user_model.dart';
import 'package:attendance/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance/base_file.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final isLoading = StateProvider.autoDispose<bool>((ref) => false);

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
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final res = await BaseFile.postMethod('login', object);
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
