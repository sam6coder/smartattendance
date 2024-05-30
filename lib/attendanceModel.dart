

class AttendanceRecord {
  final int totalPresentDays;
  final String timestamp;
  final String lastName;
  final int totalWorkingDays;
  final String rekognitionId;
  final String firstName;
  final String previousAttendanceDate;
  bool attendanceStatus;
  final int uniRollNumber;
  final String emailId;

  AttendanceRecord({
    required this.totalPresentDays,
    required this.timestamp,
    required this.lastName,
    required this.totalWorkingDays,
    required this.rekognitionId,
    required this.firstName,
    required this.previousAttendanceDate,
    required this.attendanceStatus,
    required this.uniRollNumber,
    required this.emailId
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {

    return AttendanceRecord(
      totalPresentDays: json['Total Present Days'],
      timestamp: json['Timestamp'],
      lastName: json['Last Name'],
      totalWorkingDays: json['Total Working Days'],
      rekognitionId: json['rekognitionId'],
      firstName: json['First Name'],
      previousAttendanceDate: json['Previous Attendance Date'],
      attendanceStatus: json['Attendance Status'],
      uniRollNumber: json['uni_rollnumber'],
      emailId: json['Email'],
    );

  }
}
