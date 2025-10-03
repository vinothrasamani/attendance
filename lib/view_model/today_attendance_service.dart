import 'package:attendance/base_file.dart';
import 'package:attendance/model/attendance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodayAttendanceService {
  static final todayAttendance =
      FutureProvider.autoDispose<List<AttendanceData>>((ref) async {
    try {
      final ip = ref.read(BaseFile.ip);
      final port = ref.read(BaseFile.port);
      final res = await BaseFile.getMethod('today-attendance', ip, port);
      final data = attendanceModelFromJson(res);
      if (data.success) {
        return Future.value(data.data);
      }
      return [];
    } catch (e) {
      return [];
    }
  });
}
