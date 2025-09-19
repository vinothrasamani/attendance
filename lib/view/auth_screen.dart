import 'package:attendance/install_id_manager.dart';
import 'package:attendance/main.dart';
import 'package:attendance/view_model/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _key = GlobalKey<FormState>();
  String? name, code, phone, password, token;

  @override
  void initState() {
    super.initState();
  }

  void submit(bool isLogin) async {
    if (_key.currentState!.validate()) {
      ref.read(AuthService.isLoading.notifier).state = true;
      token = await InstallIdManager.getInstallId();
      final body = {
        'name': name,
        if (!isLogin) 'phone': phone,
        if (!isLogin) 'code': code,
        'token': token,
        'password': password,
      };
      AuthService.submit(ref, body);
    }
  }

  TextFormField field({
    String? hint,
    TextInputType? type,
    IconData icon = Icons.person,
    bool obscure = false,
    Function(String)? onChanged,
  }) {
    final obs = ref.watch(AuthService.obscure);
    return TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: type,
      cursorColor: Colors.white,
      obscureText: obscure ? obs : false,
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
        suffixIcon: obscure
            ? IconButton(
                onPressed: () {
                  ref.read(AuthService.obscure.notifier).state = !obs;
                },
                icon: Icon(
                  obs ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              )
            : null,
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

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(AuthService.isLogin);
    final isLoading = ref.watch(AuthService.isLoading);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [baseColor, baseColor, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4, spreadRadius: 1, color: Colors.grey)
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          isLogin ? 'Welcome Back!' : 'Register Details!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        field(
                          hint: 'Name',
                          onChanged: (p0) {
                            name = p0;
                          },
                        ),
                        SizedBox(height: 10),
                        if (!isLogin)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                            ],
                          ),
                        field(
                          hint: 'Password',
                          obscure: true,
                          onChanged: (p0) {
                            password = p0;
                          },
                          icon: Icons.lock,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => isLoading ? null : submit(isLogin),
                            style: style,
                            icon: isLoading
                                ? SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : null,
                            label: Text(isLoading
                                ? 'Loading...'
                                : isLogin
                                    ? 'Login'
                                    : 'Sign Up'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(AuthService.isLogin.notifier).state =
                                      false;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white
                                      .withAlpha(isLogin ? 40 : 100),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      color: isLogin
                                          ? Colors.transparent
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                child: Text('Register'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(AuthService.isLogin.notifier).state =
                                      true;
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      color: !isLogin
                                          ? Colors.transparent
                                          : Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.white
                                      .withAlpha(isLogin ? 100 : 40),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Login'),
                              ),
                            ),
                          ],
                        ),
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
