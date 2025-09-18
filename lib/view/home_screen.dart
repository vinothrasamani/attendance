import 'package:attendance/main.dart';
import 'package:attendance/model/user_model.dart';
import 'package:attendance/view_model/home_service.dart';
import 'package:attendance/view_model/user_sevice.dart';
import 'package:attendance/widget/attendance.dart';
import 'package:attendance/widget/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  User? user;

  @override
  void initState() {
    ref.read(userProvider.notifier).loadUser();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider);
    final index = ref.watch(HomeService.index);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    'Welcome ${user != null ? user!.name : 'User'}!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child:
                    ref.watch(HomeService.index) == 0 ? Status() : Attendance(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 58,
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: baseColor,
        ),
        child: Row(
          children: [
            btn('Today Status', index == 0, Icons.check_circle_outline, () {
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
