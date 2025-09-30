import 'package:attendance/base_file.dart';
import 'package:attendance/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileService {
  static final profile = FutureProvider.family
      .autoDispose<ProfileData?, String?>((ref, code) async {
    try {
      final ip = ref.read(BaseFile.ip);
      final port = ref.read(BaseFile.port);
      final res = await BaseFile.getMethod('profile?code=$code', ip, port);
      final data = profileModelFromJson(res);
      if (data.success) {
        return Future.value(data.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  });

  static Future getMediaPermission() async {
    final camera = await Permission.camera.isGranted;
    if (!camera) {
      await Permission.camera.request();
    }
  }

  static void uploadProfile() async {
    try {
      double size = 300;
      XFile? image;
      await getMediaPermission();
      await Get.dialog(
        AlertDialog(
          title: Text('Choose your source!'),
          content: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  Get.back();
                  image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    maxHeight: size,
                    maxWidth: size,
                  );
                },
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset(
                    'assets/camera.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: () async {
                  Get.back();
                  image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    maxHeight: size,
                    maxWidth: size,
                  );
                },
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset(
                    'assets/gallery.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      if (image != null) {}
    } catch (e) {
      Get.snackbar(
        'Upload failed!',
        'Failed to upload profile image',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        borderRadius: 5,
      );
    }
  }
}
