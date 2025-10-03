import 'package:flutter/material.dart';

class TodayAttendanceScreen extends StatelessWidget {
  const TodayAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today Attendance'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Container(height: 0.5, color: Colors.grey),
        ),
      ),
    );
  }
}
