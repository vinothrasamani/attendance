import 'package:attendance/base_file.dart';
import 'package:attendance/main.dart';
import 'package:attendance/model/user_model.dart';
import 'package:attendance/view_model/auth_service.dart';
import 'package:attendance/view_model/home_service.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:attendance/view_model/wifi_service.dart';
import 'package:attendance/widget/attendance.dart';
import 'package:attendance/widget/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  User? user;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      load();
    });
    super.initState();
  }

  void load() async {
    final ip = ref.read(BaseFile.ip);
    final port = ref.read(BaseFile.port);
    await ref.read(userProvider.notifier).loadUser();
    ref.read(HomeService.isChecking.notifier).state = true;
    try {
      final val = await HomeService.isServerReachable(ip, port);
      ref.read(HomeService.isOk.notifier).state = val;
      if (val) {
        await HomeService.fetchStatus(ref);
      }
    } catch (e) {
      debugPrint('Error in load: $e');
      ref.read(HomeService.isOk.notifier).state = false;
    } finally {
      ref.read(HomeService.isChecking.notifier).state = false;
    }
  }

  Widget btn(String title, bool isIt, IconData icon, VoidCallback ontap) {
    Color color = isIt ? Colors.white : Colors.grey;
    return Expanded(
      child: ListTile(
        dense: true,
        onTap: ontap,
        leading: Icon(icon, color: color),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  void menu(int index) async {
    switch (index) {
      case 1:
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool('darkTheme', !Get.isDarkMode);
        Get.changeThemeMode(
          Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
        );
        break;
      case 2:
        await AuthService.refreshSchool(ref);
        break;
      default:
    }
  }

  PopupMenuItem<int> menuItem(int i, String title, IconData icon) {
    return PopupMenuItem(
      value: i,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 6),
          Text(title),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WifiService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider);
    final index = ref.watch(HomeService.index);
    final isOk = ref.watch(HomeService.isOk);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: baseColor,
                ),
                child: ListTile(
                  dense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Icon(Icons.account_circle,
                        size: 40, color: Colors.white),
                  ),
                  title: Text(
                    'Welcome ${user != null ? '${user!.firstName} ${user!.middleName ?? ''} ${user!.lastName ?? ''}' : 'User'}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<int>(
                        iconColor: Colors.white,
                        position: PopupMenuPosition.under,
                        onSelected: menu,
                        itemBuilder: (ctx) => [
                          menuItem(1, 'Theme', Icons.brightness_4),
                          menuItem(2, 'Cloud Sync', Icons.cloud_sync),
                          menuItem(3, 'Notice', Icons.message),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ref.watch(HomeService.isChecking)
                    ? Center(child: CircularProgressIndicator())
                    : !isOk
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Builder(builder: (context) {
                                    final c = Colors.red[800]!;
                                    return CircleAvatar(
                                      radius: 35,
                                      backgroundColor: c.withAlpha(50),
                                      child: Icon(
                                        Icons.wifi_off,
                                        size: 30,
                                        color: c,
                                      ),
                                    );
                                  }),
                                  SizedBox(height: 10),
                                  Text(
                                    'Couldn\'t reach the server. Please connect with an appropriate wifi!',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await WifiService.connectToWifi(
                                        ref.read(BaseFile.username),
                                        ref.read(BaseFile.password),
                                      );
                                      load();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: baseColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ref.watch(HomeService.index) == 0
                            ? Status()
                            : Attendance(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !isOk
          ? null
          : Container(
              height: 58,
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: baseColor,
              ),
              child: Row(
                children: [
                  btn('Today Status', index == 0, Icons.check_circle_outline,
                      () {
                    ref.read(HomeService.index.notifier).state = 0;
                  }),
                  VerticalDivider(color: Colors.white60),
                  btn('Attendance', index == 1, Icons.fact_check, () {
                    ref.read(HomeService.index.notifier).state = 1;
                  }),
                ],
              ),
            ),
    );
  }
}
