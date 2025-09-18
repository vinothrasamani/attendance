import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeService {
  static final isLoading = StateProvider<bool>((ref) => false);
  static final index = StateProvider((ref) => 0);
}
