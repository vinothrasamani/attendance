import 'package:attendance/base_file.dart';
import 'package:attendance/main.dart';
import 'package:attendance/view/notice_screen.dart';
import 'package:attendance/view/profile_screen.dart';
import 'package:attendance/view/student_application_screen.dart';
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

    Widget menuItem(String title, IconData icon, Widget screen) {
      return ListTile(
        onTap: () {
          Get.back();
          Get.to(() => screen, transition: Transition.rightToLeft);
        },
        leading: Icon(icon),
        title: Text(title),
      );
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
                Get.to(() => ProfileScreen(),
                    transition: Transition.leftToRightWithFade);
              },
              child: DrawerHeader(
                decoration: BoxDecoration(color: baseColor),
                child: SafeArea(
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            menuItem('Profile', Icons.person, ProfileScreen()),
            menuItem('Notice', Icons.message, NoticeScreen()),
            menuItem(
              'Student Application',
              Icons.person_add_alt_1,
              StudentApplicationScreen(isApp: true),
            ),
            menuItem(
              'Student Master',
              Icons.person_search,
              StudentApplicationScreen(
                isApp: false,
              ),
            ),
            if (user?.appAdmin == '1')
              menuItem('Today Log', Icons.today, TodayAttendanceScreen()),
          ],
        ),
      ),
    );
  }
}
