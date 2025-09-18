import 'dart:convert';

import 'package:attendance/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSevice extends StateNotifier<User?> {
  UserSevice() : super(null);

  void loadUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final user = preferences.getString('user');
    if (user != null) {
      state = User.fromJson(jsonDecode(user));
    }
  }
}

final userProvider =
    StateNotifierProvider<UserSevice, User?>((ref) => UserSevice());
