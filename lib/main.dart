import 'package:attendance/install_id_manager.dart';
import 'package:attendance/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InstallIdManager.getInstallId();
  runApp(ProviderScope(child: const MyApp()));
}

final baseColor = const Color.fromARGB(255, 3, 0, 184);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: baseColor),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
