import 'dart:convert';

import 'package:attendance/model/user_model.dart';

StatusModel statusModelFromJson(String str) =>
    StatusModel.fromJson(json.decode(str));

String statusModelToJson(StatusModel data) => json.encode(data.toJson());

class StatusModel {
  bool success;
  StatusInfo data;
  String message;

  StatusModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        success: json["success"],
        data: StatusInfo.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class StatusInfo {
  int count;
  Todayshift todayshift;
  User? user;

  StatusInfo({
    required this.count,
    required this.todayshift,
    required this.user,
  });

  factory StatusInfo.fromJson(Map<String, dynamic> json) => StatusInfo(
        count: json["count"],
        todayshift: Todayshift.fromJson(json["todayshift"]),
        user: User.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "todayshift": todayshift.toJson(),
        "user": user?.toJson(),
      };
}

class Todayshift {
  String sl;
  String oid;
  DateTime startTime;
  DateTime endTime;
  dynamic division;
  dynamic category;

  Todayshift({
    required this.sl,
    required this.oid,
    required this.startTime,
    required this.endTime,
    required this.division,
    required this.category,
  });

  factory Todayshift.fromJson(Map<String, dynamic> json) => Todayshift(
        sl: json["sl"],
        oid: json["Oid"],
        startTime: DateTime.parse(json["StartTime"]),
        endTime: DateTime.parse(json["EndTime"]),
        division: json["Division"],
        category: json["Category"],
      );

  Map<String, dynamic> toJson() => {
        "sl": sl,
        "Oid": oid,
        "StartTime": startTime.toIso8601String(),
        "EndTime": endTime.toIso8601String(),
        "Division": division,
        "Category": category,
      };
}
