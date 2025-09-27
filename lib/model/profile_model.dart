import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  bool success;
  ProfileData? data;
  String message;

  ProfileModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        success: json["success"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class ProfileData {
  String firstName;
  String? middleName;
  String? lastName;
  String staffCode;
  String? mobilePhone;
  dynamic token;
  String? appAdmin;
  String? department;
  String? designation;
  String? shiftOid;
  String? divisionOid;
  String? categoryOid;
  String? category;
  String? division;
  String? shiftname;
  String? permenantAddress;
  DateTime? dob;
  DateTime? doj;
  String? qualification;

  ProfileData({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.staffCode,
    required this.mobilePhone,
    required this.token,
    required this.appAdmin,
    required this.department,
    required this.designation,
    required this.shiftOid,
    required this.divisionOid,
    required this.categoryOid,
    required this.category,
    required this.division,
    required this.shiftname,
    required this.permenantAddress,
    required this.dob,
    required this.doj,
    required this.qualification,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        firstName: json["FirstName"],
        middleName: json["MiddleName"],
        lastName: json["LastName"],
        staffCode: json["StaffCode"],
        mobilePhone: json["MobilePhone"],
        token: json["token"],
        appAdmin: json["AppAdmin"],
        department: json["department"],
        designation: json["designation"],
        shiftOid: json["shiftOid"],
        divisionOid: json["DivisionOid"],
        categoryOid: json["CategoryOid"],
        category: json["Category"],
        division: json["Division"],
        shiftname: json["Shiftname"],
        permenantAddress: json["PermenantAddress"],
        dob: json["DOB"] == null ? null : DateTime.parse(json["DOB"]),
        doj: json["DOJ"] == null ? null : DateTime.parse(json["DOJ"]),
        qualification: json["Qualification"],
      );

  Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "MiddleName": middleName,
        "LastName": lastName,
        "StaffCode": staffCode,
        "MobilePhone": mobilePhone,
        "token": token,
        "AppAdmin": appAdmin,
        "department": department,
        "designation": designation,
        "shiftOid": shiftOid,
        "DivisionOid": divisionOid,
        "CategoryOid": categoryOid,
        "Category": category,
        "Division": division,
        "Shiftname": shiftname,
        "PermenantAddress": permenantAddress,
        "DOB": dob?.toIso8601String(),
        "DOJ": doj?.toIso8601String(),
        "Qualification": qualification,
      };
}
