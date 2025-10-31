import 'dart:convert';

StudentMasterModel studentMasterModelFromJson(String str) =>
    StudentMasterModel.fromJson(json.decode(str));

String studentMasterModelToJson(StudentMasterModel data) =>
    json.encode(data.toJson());

class StudentMasterModel {
  bool success;
  String message;
  StudentMasterData? data;

  StudentMasterModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentMasterModel.fromJson(Map<String, dynamic> json) =>
      StudentMasterModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StudentMasterData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class StudentMasterData {
  String oid;
  String? sequentialNumber;
  String admissionNo;
  DateTime admnDate;
  String applicationNo;
  String? medium;
  String classJoined;
  String? sectionJoined;
  String? optionalSubject;
  String? bloodGroup;
  String? indentificationMark1;
  String? indentificationMark2;
  String? physicalDisability;
  String? doctorName;
  String? doctorAddress;
  String? doctorPhoneNo;
  String? hostel;
  String? academicYearJoined;
  String? schoolId;
  String? currentAcademicYear;
  String? optimisticLockField;
  String? gcRecord;
  String? transport;
  String? busStopName;
  String? dataInput;
  String? photo;
  String? imageFileName;
  String? sectionGroup;
  String? status;
  int? transferCertificate;
  int? birthCertificate;
  String? rulesAndRegulations;
  String? tamilStudentName;
  String? userInput;
  String? aadharNo;
  String emis;
  String? persistentColor;
  String? tcNo;
  String? whoisWorking;
  String? rationCardNo;
  String? className;
  String? onlinePayment;
  String? userName;
  String? password;
  bool? active;
  String? mobileNo;
  String? email;
  String? message;
  String? tempAdmNo;
  String? newEmis;
  String? branch;
  String? penNo;
  String? fixedDeposit;
  String? fixedDepositAmount;
  String? apaarId;

  StudentMasterData({
    required this.oid,
    this.sequentialNumber,
    required this.admissionNo,
    required this.admnDate,
    required this.applicationNo,
    this.medium,
    required this.classJoined,
    this.sectionJoined,
    this.optionalSubject,
    this.bloodGroup,
    this.indentificationMark1,
    this.indentificationMark2,
    this.physicalDisability,
    this.doctorName,
    this.doctorAddress,
    this.doctorPhoneNo,
    this.hostel,
    this.academicYearJoined,
    this.schoolId,
    this.currentAcademicYear,
    this.optimisticLockField,
    this.gcRecord,
    this.transport,
    this.busStopName,
    this.dataInput,
    this.photo,
    this.imageFileName,
    this.sectionGroup,
    this.status,
    this.transferCertificate,
    this.birthCertificate,
    this.rulesAndRegulations,
    this.tamilStudentName,
    this.userInput,
    this.aadharNo,
    required this.emis,
    this.persistentColor,
    this.tcNo,
    this.whoisWorking,
    this.rationCardNo,
    this.className,
    this.onlinePayment,
    this.userName,
    this.password,
    this.active,
    this.mobileNo,
    this.email,
    this.message,
    this.tempAdmNo,
    this.newEmis,
    this.branch,
    this.penNo,
    this.fixedDeposit,
    this.fixedDepositAmount,
    this.apaarId,
  });

  factory StudentMasterData.fromJson(Map<String, dynamic> json) =>
      StudentMasterData(
        oid: json["Oid"],
        sequentialNumber: json["SequentialNumber"],
        admissionNo: json["AdmissionNo"],
        admnDate: DateTime.parse(json["AdmnDate"]),
        applicationNo: json["ApplicationNo"],
        medium: json["Medium"],
        classJoined: json["ClassJoined"],
        sectionJoined: json["SectionJoined"],
        optionalSubject: json["OptionalSubject"],
        bloodGroup: json["BloodGroup"],
        indentificationMark1: json["IndentificationMark1"],
        indentificationMark2: json["IndentificationMark2"],
        physicalDisability: json["PhysicalDisability"],
        doctorName: json["DoctorName"],
        doctorAddress: json["DoctorAddress"],
        doctorPhoneNo: json["DoctorPhoneNo"],
        hostel: json["Hostel"],
        academicYearJoined: json["AcademicYearJoined"],
        schoolId: json["SchoolId"],
        currentAcademicYear: json["CurrentAcademicYear"],
        optimisticLockField: json["OptimisticLockField"],
        gcRecord: json["GCRecord"],
        transport: json["Transport"],
        busStopName: json["BusStopName"],
        dataInput: json["DataInput"],
        photo: json["Photo"],
        imageFileName: json["ImageFileName"],
        sectionGroup: json["SectionGroup"],
        status: json["Status"],
        transferCertificate: json["TransferCertificate"],
        birthCertificate: json["BirthCertificate"],
        rulesAndRegulations: json["RulesAndRegulations"],
        tamilStudentName: json["TamilStudentName"],
        userInput: json["UserInput"],
        aadharNo: json["AadharNo"],
        emis: json["EMIS"],
        persistentColor: json["PersistentColor"],
        tcNo: json["TCNo"],
        whoisWorking: json["WhoisWorking"],
        rationCardNo: json["RationCardNo"],
        className: json["ClassName"],
        onlinePayment: json["OnlinePayment"],
        userName: json["UserName"],
        password: json["Password"],
        active: json["Active"],
        mobileNo: json["MobileNo"],
        email: json["Email"],
        message: json["Message"],
        tempAdmNo: json["TempAdmNo"],
        newEmis: json["NewEMIS"],
        branch: json["Branch"],
        penNo: json["PENNo"],
        fixedDeposit: json["FixedDeposit"],
        fixedDepositAmount: json["FixedDepositAmount"]?.toString(),
        apaarId: json["ApaarID"],
      );

  Map<String, dynamic> toJson() => {
        "Oid": oid,
        "SequentialNumber": sequentialNumber,
        "AdmissionNo": admissionNo,
        "AdmnDate": admnDate.toIso8601String(),
        "ApplicationNo": applicationNo,
        "Medium": medium,
        "ClassJoined": classJoined,
        "SectionJoined": sectionJoined,
        "OptionalSubject": optionalSubject,
        "BloodGroup": bloodGroup,
        "IndentificationMark1": indentificationMark1,
        "IndentificationMark2": indentificationMark2,
        "PhysicalDisability": physicalDisability,
        "DoctorName": doctorName,
        "DoctorAddress": doctorAddress,
        "DoctorPhoneNo": doctorPhoneNo,
        "Hostel": hostel,
        "AcademicYearJoined": academicYearJoined,
        "SchoolId": schoolId,
        "CurrentAcademicYear": currentAcademicYear,
        "OptimisticLockField": optimisticLockField,
        "GCRecord": gcRecord,
        "Transport": transport,
        "BusStopName": busStopName,
        "DataInput": dataInput,
        "Photo": photo,
        "ImageFileName": imageFileName,
        "SectionGroup": sectionGroup,
        "Status": status,
        "TransferCertificate": transferCertificate,
        "BirthCertificate": birthCertificate,
        "RulesAndRegulations": rulesAndRegulations,
        "TamilStudentName": tamilStudentName,
        "UserInput": userInput,
        "AadharNo": aadharNo,
        "EMIS": emis,
        "PersistentColor": persistentColor,
        "TCNo": tcNo,
        "WhoisWorking": whoisWorking,
        "RationCardNo": rationCardNo,
        "ClassName": className,
        "OnlinePayment": onlinePayment,
        "UserName": userName,
        "Password": password,
        "Active": active,
        "MobileNo": mobileNo,
        "Email": email,
        "Message": message,
        "TempAdmNo": tempAdmNo,
        "NewEMIS": newEmis,
        "Branch": branch,
        "PENNo": penNo,
        "FixedDeposit": fixedDeposit,
        "FixedDepositAmount": fixedDepositAmount,
        "ApaarID": apaarId,
      };
}
