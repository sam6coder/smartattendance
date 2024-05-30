import 'package:http/http.dart' as http;
import 'dart:convert';
import 'attendanceModel.dart';


Future<List<AttendanceRecord>> fetchData() async {
  final response = await http.get(Uri.parse('https://gjhv06ok23.execute-api.ap-south-1.amazonaws.com/GetDataAll'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List<dynamic> data = jsonResponse['data'];
    return data.map((json) => AttendanceRecord.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load attendance records');
  }
}

Future<AttendanceRecord> fetchLatestData() async {
  final response = await http.get(Uri.parse('https://djursn1gsd.execute-api.ap-south-1.amazonaws.com/getlatestdata'));

  if (response.statusCode == 200) {

    final jsonResponse = json.decode(response.body);
    final  data = jsonResponse['data'];
    return AttendanceRecord.fromJson(data);

  } else {
    throw Exception('Failed to load attendance records');
  }
}