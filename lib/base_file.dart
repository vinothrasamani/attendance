import 'dart:convert';

import 'package:http/http.dart' as http;

class BaseFile {
  static String baseUrl = 'http://192.168.1.6:8000/api';

  static Future<dynamic> postMethod(String endpoint, Object object) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final res = await http.post(url, body: jsonEncode(object));
    print(res.body);
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return jsonEncode({
        'success': false,
        'message': 'Something went wrong with the status code ${res.statusCode}'
      });
    }
  }
}
