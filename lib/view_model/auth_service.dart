import 'dart:convert';

import 'package:attendance/model/user_model.dart';
import 'package:attendance/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance/base_file.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final isLogin = StateProvider.autoDispose<bool>((ref) => true);
  static final obscure = StateProvider.autoDispose<bool>((ref) => true);
  static final isLoading = StateProvider.autoDispose<bool>((ref) => false);

  static void submit(WidgetRef ref, Object object) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final isl = ref.read(isLogin);
    final res = await BaseFile.postMethod(isl ? 'login' : 'register', object);
    print(res);
    final data = userModelFromJson(res);
    print(res);
    if (data.success) {
      if (!isl) {
        ref.read(isLogin.notifier).state = true;
        Get.snackbar(
          'Registered',
          'New user registered successfully!',
          borderRadius: 5,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        preferences.setString('user', jsonEncode(data.data));
        Get.offAll(() => HomeScreen());
        Get.snackbar(
          'Logged In',
          'User logged in successfully!',
          borderRadius: 5,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
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
