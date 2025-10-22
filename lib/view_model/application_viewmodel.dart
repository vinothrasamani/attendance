import 'package:attendance/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplicationViewmodel {
  static final name = StateProvider.autoDispose<String?>((ref) => null);
  static final emis = StateProvider.autoDispose<String?>((ref) => null);
  static final newEmis = StateProvider.autoDispose<String?>((ref) => null);
  static final staffName = StateProvider.autoDispose<String?>((ref) => null);
  static final addhar = StateProvider.autoDispose<String?>((ref) => null);
  static final gender = StateProvider.autoDispose<String?>((ref) => null);
  static final tcNo = StateProvider.autoDispose<String?>((ref) => null);
  static final adminNo = StateProvider.autoDispose<String?>((ref) => null);
  static final academicYear = StateProvider.autoDispose<String?>((ref) => null);
  static final classIs = StateProvider.autoDispose<String?>((ref) => null);
  static final sectionIs = StateProvider.autoDispose<String?>((ref) => null);
  static final bgrp = StateProvider.autoDispose<String?>((ref) => null);
  static final idm1 = StateProvider.autoDispose<String?>((ref) => null);
  static final idm2 = StateProvider.autoDispose<String?>((ref) => null);
  static final pds = StateProvider.autoDispose<String?>((ref) => null);
  static final imagePath = StateProvider.autoDispose<String?>((ref) => null);
  static final dob =
      StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
  static final adminDate =
      StateProvider.autoDispose<DateTime>((ref) => DateTime.now());

  Widget title(String txt, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: baseColor.withAlpha(150),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        SizedBox(width: 8),
        Text(
          txt,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  InputDecoration decoration(String label) {
    return InputDecoration(
      hintText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  String? validate(String? val) {
    if (val == null || val.isEmpty) {
      return 'This Field is required!';
    }
    return null;
  }

  Future<DateTime?> pickADate(BuildContext context, DateTime current) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year + 50),
    );
  }

  static Future getMediaPermission() async {
    final camera = await Permission.camera.isGranted;
    if (!camera) {
      await Permission.camera.request();
    }
  }

  Future<void> pickImage(WidgetRef ref) async {
    double size = 1080;
    await getMediaPermission();
    await Get.dialog(
      AlertDialog(
        title: Text('Upload Student Image', overflow: TextOverflow.ellipsis),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                Get.back();
                final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    maxHeight: size,
                    maxWidth: size);
                if (image != null) {
                  ref.read(imagePath.notifier).state = image.path;
                }
              },
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.asset('assets/camera.png', fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 15),
            GestureDetector(
              onTap: () async {
                Get.back();
                final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    maxHeight: size,
                    maxWidth: size);
                if (image != null) {
                  ref.read(imagePath.notifier).state = image.path;
                }
              },
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.asset('assets/gallery.png', fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
