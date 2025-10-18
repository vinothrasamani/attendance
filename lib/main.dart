import 'package:attendance/install_id_manager.dart';
import 'package:attendance/view/splash_screen.dart';
import 'package:attendance/view_model/wifi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WifiService().init();
  await InstallIdManager.getInstallId();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light),
  );
  runApp(ProviderScope(child: const MyApp()));
}

final baseColor = const Color.fromARGB(255, 3, 0, 184);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    loadTheme();
    super.initState();
  }

  void loadTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final isDark = preferences.getBool('darkTheme');
    if (isDark != null) {
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: baseColor, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: baseColor, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
