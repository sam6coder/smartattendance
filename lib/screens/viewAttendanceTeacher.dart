import 'package:flutter/material.dart';
import 'package:smart_attendance_system/fetch.dart';
import 'package:smart_attendance_system/attendanceModel.dart';
import 'package:smart_attendance_system/screens/home_teacher.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
int date=0;

  void markAttendance(List<AttendanceRecord> records) {
    DateTime currentDate = DateTime.now();


    date=records[0].totalWorkingDays;

    for (var record in records) {
      DateTime previousDate = DateTime.parse(record.previousAttendanceDate);
      if (!isSameDate(currentDate, previousDate)) {
        record.attendanceStatus = false;
      }else
        record.attendanceStatus=true;
    }
    for(var record in records){
      if(date<record.totalWorkingDays)
        date=record.totalWorkingDays;
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }


  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('University RollNo',style: TextStyle(fontSize:25 ),)),
      DataColumn(label: Text('Name',style: TextStyle(fontSize:25 ) ),),
      DataColumn(label: Text('Attendance Status',style: TextStyle(fontSize:25 ))),
      DataColumn(label: Text('Previous Attendance Date',style: TextStyle(fontSize:25 ))),
      DataColumn(label: Text('Total Present Days',style: TextStyle(fontSize:25 ))),
      DataColumn(label: Text('Total Working Days',style: TextStyle(fontSize:25))),
      DataColumn(label: Text('Timestamp',style: TextStyle(fontSize:25 ))),
    ];
  }

  List<DataRow> _createRows(List<AttendanceRecord> records) {
    return records.map((record) {
      markAttendance(records);
      return DataRow(cells: [
        DataCell(Text(record.uniRollNumber.toString(),style: TextStyle(fontSize:20 ),)),
        DataCell(Text('${record.firstName} ${record.lastName}',style: TextStyle(fontSize:20 ))),
        DataCell(Text(record.attendanceStatus?'Present':'Absent',style: TextStyle(fontSize:20 ))),
        DataCell(Text(record.previousAttendanceDate,style: TextStyle(fontSize:20 ))),
        DataCell(Text(record.totalPresentDays.toString())),
        DataCell(Text(date.toString(),style: TextStyle(fontSize:20 ))),
        DataCell(Text(record.timestamp.toString(),style: TextStyle(fontSize:20 ))),
      ]);
    }).toList();
  }

late Future<List<AttendanceRecord>> futureAttendanceRecords;


@override
  void initState() {
    super.initState();
futureAttendanceRecords=fetchData();


}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeTeacherScreen()));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(18, 22, 108, 2),
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(
            'View Attendance',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          )),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<AttendanceRecord>>(
              future: futureAttendanceRecords,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<AttendanceRecord> records = snapshot.data!;
                  markAttendance(records);

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent[100],
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),

                      ),

                      columns: _createColumns(),
                      rows: _createRows(records),
                    ),
                  );

                } else {
                  return Text('No data available');
                }
              },
            ),
          ),
        ),

    );
  }

}
