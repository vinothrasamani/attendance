import 'package:attendance/main.dart';
import 'package:attendance/view/auth_screen.dart';
import 'package:attendance/view/biometric_screen.dart';
import 'package:attendance/view_model/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    Widget screen = AuthScreen();
    await Future.delayed(Duration(seconds: 2), () async {
      await AuthService.checkSelectionStatus(ref);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final user = preferences.getString('user');
      if (user != null) {
        screen = BiometricScreen();
      } else {
        final canDo = ref.read(AuthService.canSelectSchool);
        if (canDo) {
          await AuthService.loadSchools(ref);
        }
      }
    });
    Get.off(
      () => screen,
      transition: Transition.fade,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                clipBehavior: Clip.hardEdge,
                child: Image.asset('assets/logo.png', fit: BoxFit.cover),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  minHeight: 4,
                  color: baseColor,
                  backgroundColor: const Color.fromARGB(24, 94, 94, 94),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
