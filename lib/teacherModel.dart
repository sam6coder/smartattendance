class Student {
  String name;
  String mobileNumber;
  String department;
  String collegeEmail;
  Map<int, String> subjectCode;
  Map<int,String> subjectName;

  Student({
    required this.name,
    required this.mobileNumber,
    required this.department,
    required this.collegeEmail,
    required this.subjectCode,
    required this.subjectName
  });

  factory Student.fromJson(Map<dynamic, dynamic> json) {
    Map<int, String> subjectCode;
    Map<int, String> subjectName;

    if (json['Subject_code'] is Map) {
      subjectCode = (json['Subject_code'] as Map<dynamic, dynamic>).map((key, value) => MapEntry(int.parse(key), value as String));
    } else if (json['Subject_code'] is List) {
      subjectCode = (json['Subject_code'] as List<dynamic>).asMap().map((key, value) => MapEntry(key, value as String));
    } else {
      subjectCode = {};
    }
    if (json['Subject_name'] is Map) {
      subjectName = (json['Subject_name'] as Map<dynamic, dynamic>).map((key, value) => MapEntry(int.parse(key), value as String));
    } else if (json['Subject_code'] is List) {
      subjectName = (json['Subject_name'] as List<dynamic>).asMap().map((key, value) => MapEntry(key, value as String));
    } else {
      subjectName = {};
    }

    return Student(
      name: json['Name'] as String,
      mobileNumber: json['Mobile_number'].toString() as String,
      department: json['Department'] as String,
      collegeEmail: json['College_email'] as String,
      subjectCode: subjectCode,
      subjectName: subjectName
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'department': department,
      'college_email': collegeEmail,
      'Subject_code': subjectCode.map((key, value) => MapEntry(key.toString(), value)),
      'Subject_name': subjectName.map((key, value) => MapEntry(key.toString(), value)),

    };
  }
}

// class SubjectCode {
//   String code;
//
//   SubjectCode({ required this.code});
//
//   factory SubjectCode.fromJson(dynamic json) {
//     return SubjectCode(
//       code: json as String,
//     );
//   }
//
//
// }
//
// class UserData {
//   String name;
//   String mobileNumber;
//   Map<int, SubjectCode> subjectCodes;
//
//   UserData({required this.name, required this.subjectCodes,});
//
//   factory UserData.fromJson(Map<dynamic, dynamic> json) {
//     var subjectCodesFromJson = json['Subject_code'] as Map<dynamic, dynamic>;
//     Map<int, SubjectCode> subjectCodes = {};
//     subjectCodesFromJson.forEach((key, value) {
//       subjectCodes[int.parse(key)] = SubjectCode.fromJson(value);
//     });
//     return UserData(
//       name: json['name'] as String,
//       subjectCodes: subjectCodes,
//     );
//   }
// }