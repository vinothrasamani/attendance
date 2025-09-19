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
  int id;
  DateTime? checkIn;
  DateTime? checkOut;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  AttendanceData({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        id: json["id"],
        checkIn: DateTime.parse(json["check_in"]),
        checkOut: json["check_out"] == null
            ? null
            : DateTime.parse(json["check_out"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "check_in": checkIn?.toIso8601String(),
        "check_out": checkOut?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_id": userId,
      };
}
