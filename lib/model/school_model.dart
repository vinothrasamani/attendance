import 'dart:convert';

SchoolModel schoolModelFromJson(String str) =>
    SchoolModel.fromJson(json.decode(str));

String schoolModelToJson(SchoolModel data) => json.encode(data.toJson());

class SchoolModel {
  bool success;
  List<SchoolData> data;
  String message;

  SchoolModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
        success: json["success"],
        data: List<SchoolData>.from(
            json["data"].map((x) => SchoolData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class SchoolData {
  int id;
  String school;
  String ip;
  int port;
  String username;
  String password;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  SchoolData({
    required this.id,
    required this.school,
    required this.ip,
    required this.port,
    required this.username,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory SchoolData.fromJson(Map<String, dynamic> json) => SchoolData(
        id: json["id"],
        school: json["school"],
        ip: json["ip"],
        port: json["port"],
        username: json["wifi_name"],
        password: json["wifi_password"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "school": school,
        "ip": ip,
        "port": port,
        "wifi_name": username,
        "wifi_password": password,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
