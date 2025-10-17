import 'package:attendance/base_file.dart';
import 'package:attendance/view/notice_screen.dart';
import 'package:attendance/view/profile_screen.dart';
import 'package:attendance/view/today_attendance_screen.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  Get.to(() => ProfileScreen(),
                      transition: Transition.leftToRightWithFade);
                },
                child: DrawerHeader(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: BaseFile.getImage(user?.staffCode),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/person.png'),
                                foregroundImage: MemoryImage(snap.data!),
                              );
                            }
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/person.png'),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          (user != null
                                  ? '${user.firstName} ${user.middleName ?? ''} ${user.lastName ?? ''}'
                                  : 'User')
                              .trim(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => ProfileScreen(),
                    transition: Transition.rightToLeft);
              },
              leading: Icon(Icons.person),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => NoticeScreen(),
                    transition: Transition.rightToLeft);
              },
              leading: Icon(Icons.message),
              title: Text('Notice'),
            ),
            if (user?.appAdmin == '1')
              ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => TodayAttendanceScreen(),
                      transition: Transition.rightToLeft);
                },
                leading: Icon(Icons.today),
                title: Text('Today Log'),
              ),
          ],
        ),
      ),
    );
  }
}
