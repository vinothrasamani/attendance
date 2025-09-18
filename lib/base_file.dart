import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseFile {
  static String baseUrl = 'http://192.168.1.9:8000/api';

  static Future<dynamic> postMethod(String endpoint, Object object) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      print(object);
      print(url);
      final res = await http.post(url, body: jsonEncode(object), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });
      print(res.body);
      if (res.statusCode == 200) {
        return res.body;
      } else {
        return jsonEncode({
          'success': false,
          'message':
              'Something went wrong with the status code ${res.statusCode}'
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
