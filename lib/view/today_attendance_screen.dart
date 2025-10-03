import 'package:attendance/main.dart';
import 'package:attendance/model/attendance_model.dart';
import 'package:attendance/view_model/today_attendance_service.dart';
import 'package:attendance/widget/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TodayAttendanceScreen extends ConsumerWidget {
  const TodayAttendanceScreen({super.key});

  Widget infoCard(AttendanceData data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Colors.grey.withAlpha(30),
      margin: EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading: CircleAvatar(
              backgroundColor:
                  Get.isDarkMode ? baseColor : Colors.lightBlueAccent,
              foregroundColor: Colors.white,
              child: Icon(
                data.deviceName?.toLowerCase() == 'mobile'
                    ? Icons.phone_android
                    : Icons.on_device_training,
                size: 26,
              ),
            ),
            title: Text(
              data.name ?? 'Unknown User',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Colors.green,
              ),
              child: Text(
                data.employeeCode,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              timing(Colors.green, data.inTime),
              SizedBox(width: 10),
              timing(Colors.redAccent, data.outTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget timing(Color color, DateTime? time) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color.withAlpha(40),
          border: Border.all(color: color.withAlpha(120)),
        ),
        alignment: Alignment.center,
        child: Text(
          time != null && time.year != 1900
              ? DateFormat('hh:mm a').format(time)
              : 'None',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listener = ref.watch(TodayAttendanceService.todayAttendance);

    return Scaffold(
      appBar: AppBar(
        title: Text('Today Attendance'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Container(height: 0.5, color: Colors.grey),
        ),
      ),
      body: SafeArea(
        child: listener.when(
          data: (snap) {
            if (snap.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  bool can = false;
                  final data = snap[index];
                  if (index != 0) {
                    if (snap[index - 1].category != data.category) {
                      can = true;
                    }
                  }
                  return Column(
                    children: [
                      if (can || index == 0)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Text(
                            '${data.category ?? 'Unknown'} ✨',
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.lightBlueAccent
                                  : baseColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      infoCard(data),
                    ],
                  );
                },
                itemCount: snap.length,
              );
            }
            return Center(
              child: Column(
                children: [
                  Icon(Icons.filter_list_off, size: 40),
                  SizedBox(height: 10),
                  Text('No records found!'),
                ],
              ),
            );
          },
          error: (error, _) {
            return ErrorCard(
              icon: Icons.error,
              err: 'Unable to load today attendance, try again later!',
            );
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
