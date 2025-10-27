import 'dart:convert';

CredentialsModel credentialsModelFromJson(String str) =>
    CredentialsModel.fromJson(json.decode(str));

String credentialsModelToJson(CredentialsModel data) =>
    json.encode(data.toJson());

class CredentialsModel {
  bool success;
  Credentials data;
  String message;

  CredentialsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CredentialsModel.fromJson(Map<String, dynamic> json) =>
      CredentialsModel(
        success: json["success"],
        data: Credentials.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Credentials {
  List<CredentialInfo> dataClass, gender, phys, pGroup;

  Credentials({
    required this.dataClass,
    required this.gender,
    required this.phys,
    required this.pGroup,
  });

  factory Credentials.fromJson(Map<String, dynamic> json) => Credentials(
        dataClass: List<CredentialInfo>.from(
            json["class"].map((x) => CredentialInfo.fromJson(x))),
        gender: List<CredentialInfo>.from(
            json["gender"].map((x) => CredentialInfo.fromJson(x))),
        phys: List<CredentialInfo>.from(
            json["phys"].map((x) => CredentialInfo.fromJson(x))),
        pGroup: List<CredentialInfo>.from(
            json["pGroup"].map((x) => CredentialInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "class": List<dynamic>.from(dataClass.map((x) => x.toJson())),
        "gender": List<dynamic>.from(gender.map((x) => x.toJson())),
        "phys": List<dynamic>.from(phys.map((x) => x.toJson())),
        "pGroup": List<dynamic>.from(pGroup.map((x) => x.toJson())),
      };
}

class CredentialInfo {
  String oid;
  String description;

  CredentialInfo({
    required this.oid,
    required this.description,
  });

  factory CredentialInfo.fromJson(Map<String, dynamic> json) => CredentialInfo(
        oid: json["Oid"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "Oid": oid,
        "Description": description,
      };
}
