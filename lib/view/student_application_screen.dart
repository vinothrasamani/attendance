import 'package:flutter/material.dart';

class StudentApplicationScreen extends StatefulWidget {
  const StudentApplicationScreen({super.key});

  @override
  State<StudentApplicationScreen> createState() =>
      _StudentApplicationScreenState();
}

class _StudentApplicationScreenState extends State<StudentApplicationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Application')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
