import 'dart:convert';

StudentModel sibilingModelFromJson(String str) =>
    StudentModel.fromJson(json.decode(str));

String sibilingModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  bool success;
  StudentData? data;
  String message;

  StudentModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        success: json["success"],
        data: json["data"] == null ? null : StudentData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class StudentData {
  String oid;
  String applicationNo;
  String? firstName;
  String? lastName;

  StudentData({
    required this.oid,
    required this.applicationNo,
    required this.firstName,
    required this.lastName,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
        oid: json["Oid"],
        applicationNo: json["ApplicationNo"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
      );

  Map<String, dynamic> toJson() => {
        "Oid": oid,
        "ApplicationNo": applicationNo,
        "FirstName": firstName,
        "LastName": lastName,
      };
}
