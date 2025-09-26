import 'package:attendance/base_file.dart';
import 'package:attendance/view/auth_screen.dart';
import 'package:attendance/view_model/auth_service.dart';
import 'package:attendance/view_model/wifi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class BiometricScreen extends ConsumerStatefulWidget {
  const BiometricScreen({super.key});

  @override
  ConsumerState<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends ConsumerState<BiometricScreen> {
  @override
  void initState() {
    initiate();
    super.initState();
  }

  void initiate() async {
    await WifiService.requestPermissions();
    await WifiService.connectToWifi(
        ref.read(BaseFile.username), ref.read(BaseFile.password));

    final isSupported = await AuthService.isBiomatricSupported();
    if (isSupported) {
      final canDo = await AuthService.checkBiometrics();
      if (canDo) {
        await AuthService.authendicate();
      } else {
        Get.off(() => AuthScreen(), transition: Transition.rightToLeft);
        Get.snackbar(
          'Biometrics Unavailable!',
          'Please use the login form to continue.',
          borderRadius: 5,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } else {
      Get.off(() => AuthScreen(), transition: Transition.rightToLeft);
      Get.snackbar(
        'Not Supported!',
        'Device doesn\'t support local authentications!',
        borderRadius: 5,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 145, 197),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Image.asset('assets/biometric.png'),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Use biometric for a quick access',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: OutlinedButton(
                          onPressed: () {
                            initiate();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.white),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: Text('Retry'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.off(() => AuthScreen(),
                                transition: Transition.rightToLeft);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: Text('Login'),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
