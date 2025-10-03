import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final bool success;
  final User? data;
  final String message;

  UserModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"],
        data: json["data"] == null ? null : User.fromJson(json["data"]),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class User {
  final String oid;
  final String? sequentialNumber;
  final String? applicationNo;
  final String? department;
  final String? designation;
  final String? grade;
  final String? type;
  final String? shift;
  final String? weekOff;
  final String? doj;
  final String? fatherName;
  final String? employeeCodeInDevice;
  final String? attendanceMachineIntegrated;
  final String? gender;
  final String? maritalStatus;
  final String? nationality;
  final String? religion;
  final String? dob;
  final String? pfApplicable;
  final String? esiApplicable;
  final String? ptApplicable;
  final String? aadharNo;
  final String? panNo;
  final String? appointAs;
  final String? wagesType;
  final String? salaryBasisOn;
  final String? paymentType;
  final String? bankName;
  final String? branchName;
  final String? accountNo;
  final String? otApplicable;
  final String? otRate;
  final String? status;
  final String? companyId;
  final String? branchId;
  final String? mobilePhone;
  final String? optimisticLockField;
  final String staffCode;
  final String? empDivision;
  final String? division;
  final String? incrementDate;
  final String? category;
  final String? title;
  final String firstName;
  final String? qualification;
  final String? bankBranch;
  final String? ifscCode;
  final String? token;
  final String? photo;
  final String? manager;
  final String? permanentAddress;
  final String? presentAddress;
  final String? bloodGroup;
  final String? email;
  final String? officeEmail;
  final String? otherPhone;
  final String? officePhone;
  final String? homePhone;
  final String? fax;
  final String? gcRecord;
  final String? staffid;
  final String? pfNo;
  final String? esiNo;
  final String? middleName;
  final String? lastName;
  final String? noOfExperience;
  final String? relieveDate;
  final String? dailyWages;
  final String? travelAllowance;
  final String? thisMonthAllowPf;
  final String? thisMonthAllowEsi;
  final String? signature;
  final String? pfJoinDate;
  final String? esiJoinDate;
  final String? id;
  final String? appAdmin;

  User({
    required this.oid,
    this.sequentialNumber,
    this.applicationNo,
    this.department,
    this.designation,
    this.grade,
    this.type,
    this.shift,
    this.weekOff,
    this.doj,
    this.fatherName,
    this.employeeCodeInDevice,
    this.attendanceMachineIntegrated,
    this.gender,
    this.maritalStatus,
    this.nationality,
    this.religion,
    this.dob,
    this.pfApplicable,
    this.esiApplicable,
    this.ptApplicable,
    this.aadharNo,
    this.panNo,
    this.appointAs,
    this.wagesType,
    this.salaryBasisOn,
    this.paymentType,
    this.bankName,
    this.branchName,
    this.accountNo,
    this.otApplicable,
    this.otRate,
    this.status,
    this.companyId,
    this.branchId,
    this.mobilePhone,
    this.optimisticLockField,
    required this.staffCode,
    this.empDivision,
    this.division,
    this.incrementDate,
    this.category,
    this.title,
    required this.firstName,
    this.qualification,
    this.bankBranch,
    this.ifscCode,
    this.token,
    this.photo,
    this.manager,
    this.permanentAddress,
    this.presentAddress,
    this.bloodGroup,
    this.email,
    this.officeEmail,
    this.otherPhone,
    this.officePhone,
    this.homePhone,
    this.fax,
    this.gcRecord,
    this.staffid,
    this.pfNo,
    this.esiNo,
    this.middleName,
    this.lastName,
    this.noOfExperience,
    this.relieveDate,
    this.dailyWages,
    this.travelAllowance,
    this.thisMonthAllowPf,
    this.thisMonthAllowEsi,
    this.signature,
    this.pfJoinDate,
    this.esiJoinDate,
    this.id,
    this.appAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      oid: json["Oid"],
      sequentialNumber: json["SequentialNumber"],
      applicationNo: json["ApplicationNo"],
      department: json["Department"],
      designation: json["Designation"],
      grade: json["Grade"],
      type: json["Type"],
      shift: json["Shift"],
      weekOff: json["WeekOff"],
      doj: json["DOJ"],
      fatherName: json["FatherName"],
      employeeCodeInDevice: json["EmployeeCodeInDevice"],
      attendanceMachineIntegrated: json["AttendanceMachineIntegrated"],
      gender: json["Gender"],
      maritalStatus: json["MaritalStatus"],
      nationality: json["Nationality"],
      religion: json["Religion"],
      dob: json["DOB"],
      pfApplicable: json["PFApplicable"],
      esiApplicable: json["ESIApplicable"],
      ptApplicable: json["PTApplicable"],
      aadharNo: json["AadharNo"],
      panNo: json["PANNo"],
      appointAs: json["AppointAs"],
      wagesType: json["WagesType"],
      salaryBasisOn: json["SalaryBasisOn"],
      paymentType: json["PaymentType"],
      bankName: json["BankName"],
      branchName: json["BranchName"],
      accountNo: json["AccountNo"],
      otApplicable: json["OTApplicable"],
      otRate: json["OTRate"],
      status: json["Status"],
      companyId: json["CompanyId"],
      branchId: json["BranchId"],
      mobilePhone: json["MobilePhone"],
      optimisticLockField: json["OptimisticLockField"],
      staffCode: json["StaffCode"],
      empDivision: json["EmpDivision"],
      division: json["Division"],
      incrementDate: json["IncrementDate"],
      category: json["Category"],
      title: json["Title"],
      firstName: json["FirstName"],
      qualification: json["Qualification"],
      bankBranch: json["BankBranch"],
      ifscCode: json["IFSCCode"],
      token: json["token"] ?? '',
      photo: json["Photo"],
      manager: json["Manager"],
      permanentAddress: json["PermanentAddress"],
      presentAddress: json["PresentAddress"],
      bloodGroup: json["BloodGroup"],
      email: json["Email"],
      officeEmail: json["OfficeEmail"],
      otherPhone: json["OtherPhone"],
      officePhone: json["OfficePhone"],
      homePhone: json["HomePhone"],
      fax: json["Fax"],
      gcRecord: json["GCRecord"],
      staffid: json["Staffid"],
      pfNo: json["PFNo"],
      esiNo: json["ESINo"],
      middleName: json["MiddleName"],
      lastName: json["LastName"],
      noOfExperience: json["NoofExperience"],
      relieveDate: json["RelieveDate"],
      dailyWages: json["DailyWages"],
      travelAllowance: json["TravelAllowance"],
      thisMonthAllowPf: json["thismonthAllowPF"],
      thisMonthAllowEsi: json["thismonthAllowESI"],
      signature: json["Signature"],
      pfJoinDate: json["PFJoinDate"],
      esiJoinDate: json["ESIJoinDate"],
      id: json["id"],
      appAdmin: json['AppAdmin']);

  Map<String, dynamic> toJson() => {
        "Oid": oid,
        "SequentialNumber": sequentialNumber,
        "ApplicationNo": applicationNo,
        "Department": department,
        "Designation": designation,
        "Grade": grade,
        "Type": type,
        "Shift": shift,
        "WeekOff": weekOff,
        "DOJ": doj,
        "FatherName": fatherName,
        "EmployeeCodeInDevice": employeeCodeInDevice,
        "AttendanceMachineIntegrated": attendanceMachineIntegrated,
        "Gender": gender,
        "MaritalStatus": maritalStatus,
        "Nationality": nationality,
        "Religion": religion,
        "DOB": dob,
        "PFApplicable": pfApplicable,
        "ESIApplicable": esiApplicable,
        "PTApplicable": ptApplicable,
        "AadharNo": aadharNo,
        "PANNo": panNo,
        "AppointAs": appointAs,
        "WagesType": wagesType,
        "SalaryBasisOn": salaryBasisOn,
        "PaymentType": paymentType,
        "BankName": bankName,
        "BranchName": branchName,
        "AccountNo": accountNo,
        "OTApplicable": otApplicable,
        "OTRate": otRate,
        "Status": status,
        "CompanyId": companyId,
        "BranchId": branchId,
        "MobilePhone": mobilePhone,
        "OptimisticLockField": optimisticLockField,
        "StaffCode": staffCode,
        "EmpDivision": empDivision,
        "Division": division,
        "IncrementDate": incrementDate,
        "Category": category,
        "Title": title,
        "FirstName": firstName,
        "Qualification": qualification,
        "BankBranch": bankBranch,
        "IFSCCode": ifscCode,
        "token": token,
        "Photo": photo,
        "Manager": manager,
        "PermanentAddress": permanentAddress,
        "PresentAddress": presentAddress,
        "BloodGroup": bloodGroup,
        "Email": email,
        "OfficeEmail": officeEmail,
        "OtherPhone": otherPhone,
        "OfficePhone": officePhone,
        "HomePhone": homePhone,
        "Fax": fax,
        "GCRecord": gcRecord,
        "Staffid": staffid,
        "PFNo": pfNo,
        "ESINo": esiNo,
        "MiddleName": middleName,
        "LastName": lastName,
        "NoofExperience": noOfExperience,
        "RelieveDate": relieveDate,
        "DailyWages": dailyWages,
        "TravelAllowance": travelAllowance,
        "thismonthAllowPF": thisMonthAllowPf,
        "thismonthAllowESI": thisMonthAllowEsi,
        "Signature": signature,
        "PFJoinDate": pfJoinDate,
        "ESIJoinDate": esiJoinDate,
        "id": id,
        "AppAdmin": appAdmin,
      };
}
