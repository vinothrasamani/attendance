import 'package:attendance/base_file.dart';
import 'package:attendance/install_id_manager.dart';
import 'package:attendance/main.dart';
import 'package:attendance/model/school_model.dart';
import 'package:attendance/view_model/auth_service.dart';
import 'package:attendance/view_model/wifi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _key = GlobalKey<FormState>();
  String? code, phone, token;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    await WifiService.requestPermissions();
  }

  void submit() async {
    if (_key.currentState!.validate()) {
      ref.read(AuthService.isLoading.notifier).state = true;
      if (!ref.read(AuthService.canSelectSchool)) {
        await WifiService.connectToWifi(
          ref.read(BaseFile.username),
          ref.read(BaseFile.password),
        );
      }
      token = await InstallIdManager.getInstallId();
      final body = {'phone': phone, 'code': code, 'token': token};
      AuthService.submit(ref, body);
    }
  }

  TextFormField field({
    String? hint,
    TextInputType? type,
    IconData icon = Icons.person,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: type,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
          shadows: [
            Shadow(offset: Offset(0.1, 0.6), color: Colors.black54),
          ],
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white24,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "$hint is required!" : null,
      onChanged: onChanged,
    );
  }

  final style = ElevatedButton.styleFrom(
    padding: EdgeInsets.all(15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Widget schoolCard(SchoolData sd) {
    return InkWell(
      onTap: () async {
        ref.read(BaseFile.ip.notifier).state = sd.ip;
        ref.read(BaseFile.port.notifier).state = sd.port;
        ref.read(BaseFile.username.notifier).state = sd.username;
        ref.read(BaseFile.password.notifier).state = sd.password;
        ref.read(AuthService.canSelectSchool.notifier).state = false;
        await AuthService.saveSchool(sd);
        await WifiService.connectToWifi(sd.username, sd.password);
      },
      splashColor: Colors.white,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white24,
        ),
        child: Text(
          sd.school,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(AuthService.isLoading);
    final canselect = ref.watch(AuthService.canSelectSchool);
    final size = MediaQuery.of(context).size;
    final schoolList = ref.watch(AuthService.schoolList);

    final dec = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        colors: [baseColor, baseColor, Colors.lightBlueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(blurRadius: 4, spreadRadius: 1, color: Colors.grey)
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${canselect ? 'Select' : 'Login'} to Continue'),
        centerTitle: canselect ? true : false,
        backgroundColor: baseColor,
        foregroundColor: Colors.white,
        actions: [
          if (!canselect)
            ref.watch(AuthService.refreshing)
                ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : IconButton(
                    onPressed: () => AuthService.refreshSchool(ref),
                    icon: Icon(Icons.cloud_sync),
                  ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        color: baseColor,
        child: Text(
          '© Attendance, All rights reserved.',
          style: TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: canselect
                ? Container(
                    decoration: dec,
                    padding: EdgeInsets.all(20),
                    constraints: BoxConstraints(maxHeight: size.height * 0.8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 30,
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: Text(
                            'Choose your location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        for (var item in schoolList) schoolCard(item),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        decoration: dec,
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _key,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              field(
                                hint: 'Phone',
                                icon: Icons.phone,
                                type: TextInputType.phone,
                                onChanged: (p0) {
                                  phone = p0;
                                },
                              ),
                              SizedBox(height: 10),
                              field(
                                  hint: 'Staff Code',
                                  onChanged: (p0) {
                                    code = p0;
                                  },
                                  icon: Icons.person_pin_rounded),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading ? null : submit,
                                    style: style,
                                    icon: isLoading
                                        ? SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                    label: Text(
                                      isLoading ? 'Logging In...' : 'Login',
                                      style: TextStyle(
                                        color: isLoading
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/logo.png'),
                          ),
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
