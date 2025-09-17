import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance/base_file.dart';

class AuthService {
  static final isLogin = StateProvider.autoDispose<bool>((ref) => true);
  static final obscure = StateProvider.autoDispose<bool>((ref) => true);
  static final isLoading = StateProvider.autoDispose<bool>((ref) => false);

  static void submit(WidgetRef ref, Object object) async {
    final res = await BaseFile.postMethod(
      ref.read(isLogin) ? 'login' : 'register',
      object,
    );
    debugPrint(res);
    ref.read(isLoading.notifier).state = false;
  }
}
