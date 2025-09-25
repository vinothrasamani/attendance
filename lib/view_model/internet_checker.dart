import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  static Future<bool> isWifi() async {
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.none)) {
      return true;
    } else {
      return false;
    }
  }
}
