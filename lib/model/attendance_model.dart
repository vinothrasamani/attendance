import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) =>
    AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) =>
    json.encode(data.toJson());

class AttendanceModel {
  bool success;
  List<AttendanceData> data;
  String message;

  AttendanceModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        success: json["success"],
        data: List<AttendanceData>.from(
            json["data"].map((x) => AttendanceData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class AttendanceData {
  String employeeCode;
  String? deviceName;
  DateTime date;
  DateTime? inTime;
  DateTime? outTime;

  AttendanceData({
    required this.employeeCode,
    required this.deviceName,
    required this.date,
    required this.inTime,
    required this.outTime,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        employeeCode: json["EmployeeCode"],
        deviceName: json["DeviceName"],
        date: DateTime.parse(json["Date"]),
        inTime: DateTime.parse(json["InTime"]),
        outTime: DateTime.parse(json["OutTime"]),
      );

  Map<String, dynamic> toJson() => {
        "EmployeeCode": employeeCode,
        "DeviceName": deviceName,
        "Date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "InTime": inTime?.toIso8601String(),
        "OutTime": outTime?.toIso8601String(),
      };
}
