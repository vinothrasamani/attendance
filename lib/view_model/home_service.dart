import 'dart:convert';

import 'package:attendance/base_file.dart';
import 'package:attendance/model/attendance_model.dart';
import 'package:attendance/view/auth_screen.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  static final isLoading = StateProvider<bool>((ref) => false);
  static final isChecking = StateProvider<bool>((ref) => false);
  static final isOk = StateProvider<bool>((ref) => false);
  static final current = StateProvider<bool>((ref) => false);
  static final index = StateProvider<int>((ref) => 0);
  static final focusedDay = StateProvider<DateTime>((ref) => DateTime.now());
  static final selectedDay = StateProvider<DateTime?>((ref) => null);
  static final attendanceData =
      StateProvider<Map<DateTime, String>>((ref) => {});
  static final list = StateProvider<List<AttendanceData>>((ref) => []);

  static Future<void> fetchAttendance(WidgetRef ref, DateTime day) async {
    ref.read(isLoading.notifier).state = true;
    final user = ref.read(userProvider);

    if (user == null) {
      ref.read(isLoading.notifier).state = false;
      return;
    }

    try {
      final ip = ref.read(BaseFile.ip);
      final port = ref.read(BaseFile.port);
      final formattedDay =
          "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
      final res = await BaseFile.getMethod(
          'fetch-attendance?code=${user.staffCode}&day=$formattedDay',
          ip,
          port);
      final data = attendanceModelFromJson(res);
      if (data.success) {
        ref.read(list.notifier).state = data.data;
        final Map<DateTime, String> newAttendanceData = {};
        for (var item in data.data) {
          final status = _calculateAttendanceStatus(item);
          newAttendanceData[DateTime.utc(
              item.date.year, item.date.month, item.date.day)] = status;
        }

        ref.read(attendanceData.notifier).state = newAttendanceData;
      }
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
    } finally {
      ref.read(isLoading.notifier).state = false;
    }
  }

  static String _calculateAttendanceStatus(AttendanceData item) {
    if (item.inTime == null) {
      return "Absent";
    }

    if (item.outTime == null || item.outTime?.year == 1900) {
      return "In Complete";
    }

    final start = item.inTime!;
    final end = item.outTime!;
    final durationInMinutes = end.difference(start).inMinutes;
    final durationInHours = durationInMinutes / 60;

    if (durationInHours >= 8) {
      return "Present";
    } else if (durationInHours >= 4) {
      return "Half Day";
    } else {
      return "Absent";
    }
  }

  static Future<void> fetchStatus(WidgetRef ref) async {
    final ip = ref.read(BaseFile.ip);
    final port = ref.read(BaseFile.port);
    final user = ref.read(userProvider);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final res = await BaseFile.getMethod(
        'fetch-status?code=${user?.staffCode}&day=${DateTime.now()}', ip, port);
    final data = jsonDecode(res);
    if (data["success"]) {
      if (!data['data']['user']) {
        await preferences.remove('user');
        Get.offAll(() => AuthScreen(), transition: Transition.leftToRight);
        Get.snackbar(
          'Logged Out',
          'Invalid user, Please login with credential',
          borderRadius: 5,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
      final len = data['data']['count'];
      ref.read(current.notifier).state = len == 0 || len > 1 ? false : true;
    }
  }

  static Future<bool> addStatus(WidgetRef ref, bool b) async {
    final user = ref.read(userProvider);
    final ip = ref.read(BaseFile.ip);
    final port = ref.read(BaseFile.port);
    final res = await BaseFile.postMethod(
        'check-status', {'userId': user?.oid}, ip, port);
    final data = jsonDecode(res);
    if (data['success']) {
      ref.read(current.notifier).state = b;
      Get.snackbar(
        'Success',
        data['message'],
        borderRadius: 5,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } else {
      ref.read(current.notifier).state = !b;
      Get.snackbar(
        'Failed',
        data['message'],
        borderRadius: 5,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
  }

  static Future<bool> isServerReachable(String ip, int port) async {
    try {
      final socket = await Socket.connect(ip.trim(), port,
          timeout: const Duration(seconds: 3));
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }
}
