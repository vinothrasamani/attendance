import 'dart:convert';

import 'package:attendance/base_file.dart';
import 'package:attendance/model/profile_model.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static void uploadImage(XFile? image, WidgetRef ref) async {
    double size = 1080;
    final user = ref.read(userProvider);
    final ip = ref.read(BaseFile.ip);
    final port = ref.read(BaseFile.port);
    if (image != null) {
      final img = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressQuality: 100,
        maxWidth: size.toInt(),
        maxHeight: size.toInt(),
      );
      if (img != null) {
        final bytes = await img.readAsBytes();
        String base64Image = base64Encode(bytes);
        final res = await BaseFile.postMethod('update-image',
            {'source': base64Image, 'code': user?.staffCode}, ip, port);
        final data = jsonDecode(res);
        if (data['success']) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString(
              'profile_image_${user?.staffCode}', base64Image);
          Get.snackbar(
            'Uploaded',
            data['message'],
            colorText: Colors.white,
            backgroundColor: Colors.green,
            borderRadius: 6,
          );
        }
      }
    }
  }

  static void uploadProfile(WidgetRef ref) async {
    double size = 300;
    await getMediaPermission();
    await Get.dialog(
      AlertDialog(
        title: Text('Update Profile Image', overflow: TextOverflow.ellipsis),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                Get.back();
                final image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  maxHeight: size,
                  maxWidth: size,
                );
                uploadImage(image, ref);
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
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  maxHeight: size,
                  maxWidth: size,
                );
                uploadImage(image, ref);
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
  }
}
