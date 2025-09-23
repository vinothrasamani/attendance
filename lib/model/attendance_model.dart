// To parse this JSON data, do
//
//     final attendanceModel = attendanceModelFromJson(jsonString);

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
  String oid;
  String employeeCode;
  String deviceName;
  DateTime date;
  dynamic sNo;
  String inout;
  String companyId;
  String branchId;
  dynamic optimisticLockField;
  dynamic gcRecord;
  String? paymentType;
  String month;
  String year;

  AttendanceData({
    required this.oid,
    required this.employeeCode,
    required this.deviceName,
    required this.date,
    required this.sNo,
    required this.inout,
    required this.companyId,
    required this.branchId,
    required this.optimisticLockField,
    required this.gcRecord,
    required this.paymentType,
    required this.month,
    required this.year,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        oid: json["OID"],
        employeeCode: json["EmployeeCode"],
        deviceName: json["DeviceName"],
        date: DateTime.parse(json["Date"]),
        sNo: json["SNo"],
        inout: json["INOUT"],
        companyId: json["CompanyId"],
        branchId: json["BranchId"],
        optimisticLockField: json["OptimisticLockField"],
        gcRecord: json["GCRecord"],
        paymentType: json["PaymentType"],
        month: json["Month"],
        year: json["Year"],
      );

  Map<String, dynamic> toJson() => {
        "OID": oid,
        "EmployeeCode": employeeCode,
        "DeviceName": deviceName,
        "Date": date.toIso8601String(),
        "SNo": sNo,
        "INOUT": inout,
        "CompanyId": companyId,
        "BranchId": branchId,
        "OptimisticLockField": optimisticLockField,
        "GCRecord": gcRecord,
        "PaymentType": paymentType,
        "Month": month,
        "Year": year,
      };
}
