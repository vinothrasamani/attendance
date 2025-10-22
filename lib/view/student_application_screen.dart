import 'package:attendance/widget/student_application/academic_details.dart';
import 'package:attendance/widget/student_application/personal_details.dart';
import 'package:attendance/widget/student_application/student_identities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentApplicationScreen extends StatefulWidget {
  const StudentApplicationScreen({super.key});

  @override
  State<StudentApplicationScreen> createState() =>
      _StudentApplicationScreenState();
}

class _StudentApplicationScreenState extends State<StudentApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  void submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Get.snackbar(
        'Required!',
        'Please fill all the required fields to continue!',
        borderRadius: 5,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    print("✅ All details valid, submitting application...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Application')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: OutlinedButton(
            onPressed: submit,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Save Application'),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PersonalDetails(),
                  const SizedBox(height: 10),
                  const AcademicDetails(),
                  const SizedBox(height: 10),
                  const StudentIdentities(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
