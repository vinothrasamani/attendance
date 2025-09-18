import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: size.height - 200),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('data')],
          ),
        ),
      ),
    );
  }
}
