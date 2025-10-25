import 'dart:convert';

SibilingModel sibilingModelFromJson(String str) =>
    SibilingModel.fromJson(json.decode(str));

String sibilingModelToJson(SibilingModel data) => json.encode(data.toJson());

class SibilingModel {
  bool success;
  SibilingData? data;
  String message;

  SibilingModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SibilingModel.fromJson(Map<String, dynamic> json) => SibilingModel(
        success: json["success"],
        data: json["data"] == null ? null : SibilingData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class SibilingData {
  String oid;
  String applicationNo;
  String? firstName;
  String? lastName;

  SibilingData({
    required this.oid,
    required this.applicationNo,
    required this.firstName,
    required this.lastName,
  });

  factory SibilingData.fromJson(Map<String, dynamic> json) => SibilingData(
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
