import 'package:attendance/base_file.dart';
import 'package:attendance/main.dart';
import 'package:attendance/model/credentials_model.dart';
import 'package:attendance/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplicationViewmodel {
  static final name = StateProvider.autoDispose<String?>((ref) => null);
  static final emis = StateProvider.autoDispose<String?>((ref) => null);
  static final newEmis = StateProvider.autoDispose<String?>((ref) => null);
  static final staffName = StateProvider.autoDispose<String?>((ref) => null);
  static final aadhar = StateProvider.autoDispose<String?>((ref) => null);
  static final gender = StateProvider.autoDispose<String?>((ref) => null);
  static final tcNo = StateProvider.autoDispose<String?>((ref) => null);
  static final adminNo = StateProvider.autoDispose<String?>((ref) => null);
  static final appNo = StateProvider.autoDispose<String?>((ref) => null);
  static final academicYear = StateProvider.autoDispose<String?>((ref) => null);
  static final branch = StateProvider.autoDispose<String?>((ref) => null);
  static final classIs = StateProvider.autoDispose<String?>((ref) => null);
  static final sectionIs = StateProvider.autoDispose<String?>((ref) => null);
  static final bgrp = StateProvider.autoDispose<String?>((ref) => null);
  static final prefGrp = StateProvider.autoDispose<String?>((ref) => null);
  static final lastSchool = StateProvider.autoDispose<String?>((ref) => null);
  static final idm1 = StateProvider.autoDispose<String?>((ref) => null);
  static final idm2 = StateProvider.autoDispose<String?>((ref) => null);
  static final pds = StateProvider.autoDispose<String?>((ref) => null);
  static final imagePath = StateProvider.autoDispose<String?>((ref) => null);
  static final oplSub = StateProvider.autoDispose<String?>((ref) => null);
  static final penNo = StateProvider.autoDispose<String?>((ref) => null);
  static final apaarId = StateProvider.autoDispose<String?>((ref) => null);
  static final schlId = StateProvider.autoDispose<String?>((ref) => null);
  static final currAcaYear = StateProvider.autoDispose<String?>((ref) => null);
  static final secGrp = StateProvider.autoDispose<String?>((ref) => null);
  static final status = StateProvider.autoDispose<String?>((ref) => null);
  static final whoWork = StateProvider.autoDispose<String?>((ref) => null);
  static final birthCert = StateProvider.autoDispose<bool>((ref) => false);
  static final transCert = StateProvider.autoDispose<bool>((ref) => false);
  static final dob =
      StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
  static final adminDate =
      StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
  static final isLoading = StateProvider.autoDispose<bool>((ref) => false);
  static final student = StateProvider.autoDispose<StudentData?>((ref) => null);
  static final credentials =
      StateProvider.autoDispose<Credentials?>((ref) => null);

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

  static Future<void> submitInfo(WidgetRef ref, bool isApp) async {
    try {
      ref.read(isLoading.notifier).state = true;
      final myDio = dio.Dio();
      final img = ref.read(imagePath.notifier).state;
      final oId = ref.read(student)!.oid;
      final data = isApp
          ? {
              'oId': oId,
              'name': ref.read(name),
              'dob': ref.read(dob).toIso8601String().split('T').first,
              'appNo': ref.read(appNo),
              'gender': ref.read(gender),
              'class': ref.read(classIs),
              'academicYear': ref.read(academicYear),
              'branch': ref.read(branch),
              'prefGrp': ref.read(prefGrp),
              'lastSchool': ref.read(lastSchool),
              'pysicalDis': ref.read(pds),
              if (img != null)
                'image': await dio.MultipartFile.fromFile(
                  img,
                  filename: img.split('/').last,
                ),
            }
          : {
              'oId': oId,
              'adminNo': ref.read(adminNo),
              'adminDate':
                  ref.read(adminDate).toIso8601String().split('T').first,
              'emis': ref.read(emis),
              'newEmis': ref.read(newEmis),
              'staff': ref.read(staffName),
              'aadhar': ref.read(aadhar),
              'oplSub': ref.read(oplSub),
              'penNo': ref.read(penNo),
              'apaarId': ref.read(apaarId),
              'schoolId': ref.read(schlId),
              'curAcadYear': ref.read(currAcaYear),
              'secGrp': ref.read(secGrp),
              'status': ref.read(status),
              'BCert': ref.read(birthCert) ? 1 : 0,
              'TCert': ref.read(transCert) ? 1 : 0,
              'whoWork': ref.read(whoWork),
              'tcNo': ref.read(tcNo),
              'academicYear': ref.read(academicYear),
              'branch': ref.read(branch),
              'class': ref.read(classIs),
              'section': ref.read(sectionIs),
              'bloodGrp': ref.read(bgrp),
              'identity1': ref.read(idm1),
              'identity2': ref.read(idm2),
              'pysicalDis': ref.read(pds),
              if (img != null)
                'image': await dio.MultipartFile.fromFile(img,
                    filename: img.split('/').last),
            };
      print(data);
      dio.FormData formData = dio.FormData.fromMap(data);
      final res = await myDio.post(
          '${BaseFile.baseApiNetUrl}/${isApp ? 'store-application' : 'store-master'}',
          data: formData,
          options: dio.Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }));
      print('res => $res');
      if (res.statusCode == 200) {
        Get.snackbar(
          'Success!',
          isApp
              ? 'Application created successfully!'
              : 'Master saved successfully!',
          borderRadius: 5,
          backgroundColor: const Color.fromARGB(255, 0, 124, 4),
          colorText: Colors.white,
        );
      }
      ref.read(isLoading.notifier).state = false;
    } catch (e) {
      debugPrint('Error on => $e');
      ref.read(isLoading.notifier).state = false;
    }
  }

  static void fetchCredentials(WidgetRef ref) async {
    final ip = ref.read(BaseFile.ip);
    final port = ref.read(BaseFile.port);
    final res = await BaseFile.getMethod('credentials', ip, port,
        appUrl: BaseFile.baseApiNetUrl);
    final data = credentialsModelFromJson(res);
    if (data.success) {
      ref.read(credentials.notifier).state = data.data;
    }
  }

  static void fetchApplication(WidgetRef ref, String no) async {
    ref.read(isLoading.notifier).state = true;
    final ip = ref.read(BaseFile.ip);
    final port = ref.read(BaseFile.port);
    final res = await BaseFile.postMethod(
        'student-application', {"appNo": no}, ip, port,
        appUrl: BaseFile.baseApiNetUrl);
    final data = sibilingModelFromJson(res);
    if (data.success) {
      ref.read(student.notifier).state = data.data;
    } else {
      Get.snackbar(
        'Failed!',
        data.message,
        borderRadius: 5,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
    ref.read(isLoading.notifier).state = false;
  }
}
