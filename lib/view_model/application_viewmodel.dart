import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationViewmodel {
  static final name = StateProvider.autoDispose<String?>((ref) => null);
  static final emis = StateProvider.autoDispose<String?>((ref) => null);
  static final newEmis = StateProvider.autoDispose<String?>((ref) => null);
  static final staffName = StateProvider.autoDispose<String?>((ref) => null);
  static final addhar = StateProvider.autoDispose<String?>((ref) => null);
  static final image = StateProvider.autoDispose<String?>((ref) => null);
  static final gender = StateProvider.autoDispose<String?>((ref) => null);

  static final tcNo = StateProvider.autoDispose<String?>((ref) => null);
}
