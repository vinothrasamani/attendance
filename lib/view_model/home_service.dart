import 'dart:convert';

import 'package:attendance/base_file.dart';
import 'package:attendance/model/attendance_model.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class HomeService {
  static final isLoading = StateProvider<bool>((ref) => false);
  static final index = StateProvider<int>((ref) => 0);
  static final focusedDay = StateProvider<DateTime>((ref) => DateTime.now());
  static final selectedDay = StateProvider<DateTime?>((ref) => null);
  static final attendanceData =
      StateProvider<Map<DateTime, String>>((ref) => {});
  static final list =
      StateProvider<Map<String, List<AttendanceData>>>((ref) => {});

  static Future<void> fetchAttendance(WidgetRef ref, DateTime day) async {
    ref.read(isLoading.notifier).state = true;
    final user = ref.read(userProvider);

    try {
      final res = await BaseFile.getMethod(
          'fetch-attendance?code=${user?.staffCode}&&day=$day');
      print(res);
      final data = attendanceModelFromJson(res);
      if (data.success) {
        Map<String, List<AttendanceData>> grouped = {};
        for (var item in data.data) {
          final dateKey =
              '${DateTime(item.date.year, item.date.month, item.date.day)}';
          grouped.putIfAbsent((dateKey), () => []).add(item);
        }
        ref.read(list.notifier).state = grouped;
        final Map<DateTime, String> newAttendanceData = {};
        for (var entry in grouped.entries) {
          final status = _calculateAttendanceStatus(entry.value);
          newAttendanceData[DateTime.parse(entry.key)] = status;
        }
        final a = ref.read(attendanceData.notifier).state;
        a.clear();
        a.addAll(newAttendanceData);
        print(newAttendanceData);
        ref.read(isLoading.notifier).state = false;
      } else {
        ref.read(isLoading.notifier).state = false;
      }
    } catch (e) {
      print(e);
      ref.read(isLoading.notifier).state = false;
    }
  }

  static String _calculateAttendanceStatus(List<AttendanceData> punches) {
    if (punches.isEmpty) return "Absent";
    if (punches.length == 1) {
      return 'In Complete';
    }
    punches.sort((a, b) => a.date.compareTo(b.date));
    final firstIn = punches.firstWhere(
      (p) => p.inout.toLowerCase() == "in",
      orElse: () => punches.first,
    );

    final lastOut = punches.lastWhere(
      (p) => p.inout.toLowerCase() == "out",
      orElse: () => punches.last,
    );

    final durationInMinutes = lastOut.date.difference(firstIn.date).inMinutes;
    final durationInHours = durationInMinutes / 60;

    if (durationInHours >= 8) {
      return "Present";
    } else if (durationInHours >= 4) {
      return "Half Day";
    } else {
      return "Absent";
    }
  }

  static Future<bool> addStatus(WidgetRef ref) async {
    final user = ref.read(userProvider);
    final res =
        await BaseFile.postMethod('check-status', {'userId': user?.oid});
    final data = jsonDecode(res);
    if (data['success']) {
      Get.snackbar(
        'Success',
        data['message'],
        borderRadius: 5,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } else {
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
}
