import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class BaseFile {
  static final ip = StateProvider<String>((ref) => '');
  static final port = StateProvider<int>((ref) => 0000);
  static final username = StateProvider<String>((ref) => '');
  static final password = StateProvider<String>((ref) => '');
  static String baseNetworkUrl = 'https://cpanel.ijessi.com/api';

  static Future<dynamic> postMethod(
      String endpoint, Object object, String ip, int port) async {
    try {
      String baseUrl = 'http://$ip:$port/api';
      final url = Uri.parse('$baseUrl/$endpoint');
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
      debugPrint('Error : $e');
      return jsonEncode({'success': false, 'message': 'Something went wrong!'});
    }
  }

  static Future<dynamic> getMethod(String endpoint, String ip, int port) async {
    try {
      String baseUrl = 'http://$ip:$port/api';
      final url = Uri.parse('$baseUrl/$endpoint');
      final res = await http.get(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });
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
      return jsonEncode({'success': false, 'message': 'Something went wrong!'});
    }
  }
}
