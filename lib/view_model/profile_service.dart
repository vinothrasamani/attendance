import 'package:attendance/base_file.dart';
import 'package:attendance/model/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileService {
  static final profile = FutureProvider.family
      .autoDispose<ProfileData?, String?>((ref, code) async {
    try {
      final ip = ref.read(BaseFile.ip);
      final port = ref.read(BaseFile.port);
      final res = await BaseFile.getMethod('profile?code=$code', ip, port);
      final data = profileModelFromJson(res);
      if (data.success) {
        return Future.value(data.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  });
}
