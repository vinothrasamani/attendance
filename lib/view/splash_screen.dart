import 'package:attendance/main.dart';
import 'package:attendance/view/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    final Widget screen = AuthScreen();
    await Future.delayed(Duration(seconds: 2), () {
      //---check is logged in---
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
