import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class InstallIdManager {
  static const _key = "install_id";

  static Future getInstallId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_key);
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString(_key, id);
    }
    return id;
  }
}
