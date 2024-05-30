import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_attendance_system/screens/home_student.dart';
import 'package:smart_attendance_system/fetch.dart';
import 'package:smart_attendance_system/attendanceModel.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_attendance_system/attendance.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ViewAttendanceStudentScreen extends StatefulWidget {
  @override
  ViewAttendanceStudentScreenState createState() =>
      ViewAttendanceStudentScreenState();
}

class ViewAttendanceStudentScreenState
    extends State<ViewAttendanceStudentScreen> {
  late Future<List<AttendanceRecord>> attendanceList;
  String field = '';

  loadUserInfo() async {
    field = '$username ipec';
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('students/$field');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      final vals = dataSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        rollNo = vals['Univ_rollno'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    attendanceList = fetchData();
    loadUserInfo();

    //printf();
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
              MaterialPageRoute(builder: (context) => HomeStudentScreen()));
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(18, 22, 108, 2),
              automaticallyImplyLeading: false,
              title: Center(
                  child: Text(
                'Attendance Report',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )),
            ),
            backgroundColor: Color(0xFF0A0E21),
            body: FutureBuilder<List<AttendanceRecord>>(
              future: attendanceList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  print(rollNo);
                  List<AttendanceRecord> records = snapshot.data!
                      .where((record) => record.uniRollNumber == rollNo)
                      .toList();

                  if (records.length == 1) {
                    AttendanceRecord record = records[0];
                    print(record);

                    final AttendanceData datum = AttendanceData(record.firstName,record.totalPresentDays, record.totalWorkingDays);

                    double percentage =
                        (record.totalPresentDays / record.totalWorkingDays) *
                            100;
                    double percent=double.parse(percentage.toStringAsFixed(2));
                    double eligibleDays=((75-percentage)*record.totalWorkingDays)/100;
                    int el=eligibleDays.ceil();
                    int absent=record.totalWorkingDays-record.totalPresentDays;
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        AutoSizeText(
                                          'Attendance Percentage ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight
                                                  .bold), // Base font size
                                          maxLines: 2, // Maximum number of lines
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          textAlign: TextAlign
                                              .center, // Center align the text
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        AutoSizeText(
                                          ' ${percent} %',
                                          style: TextStyle(
                                              fontSize: 34,
                                              color: Colors.yellow,
                                              fontWeight: FontWeight
                                                  .bold), // Base font size
                                          maxLines: 1, // Maximum number of lines
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          textAlign: TextAlign
                                              .center, // Center align the text
                                        ),
                                      ],
                                    ),
                                    // Text('${record.firstName},',style: TextStyle(color: Colors.white),),

                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1D1E33),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(

                                  child: Container(
                                    child: Column(
                                      children: [
                                        AutoSizeText(
                                          'Total Absent Days ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight
                                                  .bold), // Base font size
                                          maxLines: 2, // Maximum number of lines
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          textAlign: TextAlign
                                              .center, // Center align the text
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        AutoSizeText(
                                          ' ${absent}',
                                          style: TextStyle(
                                              fontSize: 34,
                                              color: Colors.yellow,
                                              fontWeight: FontWeight
                                                  .bold), // Base font size
                                          maxLines: 1, // Maximum number of lines
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          textAlign: TextAlign
                                              .center, // Center align the text
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1D1E33),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:8.0),
                                        child: AutoSizeText(
                                          'Predictive Analysis ',
                                          style: TextStyle(
                                              fontSize:25,
                                              color: Colors.white,
                                              fontWeight: FontWeight
                                                  .bold), // Base font size
                                          maxLines: 2, // Maximum number of lines
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          textAlign: TextAlign
                                              .center, // Center align the text
                                        ),
                                      ),
                                      Icon(Icons.trending_up,color: Colors.red,size: 40,),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AutoSizeText(
                                    ' After attending ${el} lecture \n you are eligible for exams',
                                    style: TextStyle(
                                        fontSize: 23,
                                        color: Colors.yellow,
                                        fontWeight: FontWeight
                                            .bold), // Base font size
                                    maxLines: 2, // Maximum number of lines
                                    overflow: TextOverflow
                                        .ellipsis, // Handle overflow
                                    textAlign: TextAlign
                                        .center, // Center align the text
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF1D1E33),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Expanded(
                          flex: 2,
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF1D1E33),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(

                                  labelStyle: TextStyle(
                                    color: Colors.yellow,   // X-axis label color
                                    fontSize: 14,        // X-axis label font size
                                    fontWeight: FontWeight.bold,  // X-axis label font weight
                                  ),
                                  axisLine: AxisLine(
                                    color: Colors.white, // X-axis line color
                                    width: 2,            // X-axis line width
                                  ),
                                  majorTickLines: MajorTickLines(
                                    color: Colors.pink, // X-axis major tick color
                                    width: 2,            // X-axis major tick width
                                  ),

                                ),
                                primaryYAxis: NumericAxis(
                                  labelStyle: TextStyle(color: Colors.yellow, fontSize: 14),
                                ),
                                title: ChartTitle(text: 'Number of Present Days vs Working Days',textStyle: TextStyle(
                                  color: Colors.white,  // Title color
                                  fontSize: 25,        // Title font size
                                  fontWeight: FontWeight.bold,  // Title font weight

                                ),),

                                legend: Legend(isVisible: true,textStyle: TextStyle(
                                  color: Colors.yellow,  // Legend label color
                                  fontSize: 14,        // Legend label font size
                                  fontWeight: FontWeight.bold,  // Legend label font weight
                                ),),
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <CartesianSeries>[
                                  ColumnSeries<AttendanceData, String>(
                                    dataSource: [datum],
                                    xValueMapper: (AttendanceData attendance, _) => 'Present Days',
                                    yValueMapper: (AttendanceData attendance, _) => attendance.presentDays,
                                    name: 'Present Days',
                                    color: Colors.lightGreenAccent,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                  ),
                                  ColumnSeries<AttendanceData, String>(
                                    dataSource: [datum],
                                    xValueMapper: (AttendanceData attendance, _) => 'Working Days',
                                    yValueMapper: (AttendanceData attendance, _) => attendance.workingDays,
                                    name: 'Working Days',
                                    color: Colors.red,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                  ),
                                ],
                              ),
                            ),
                          )

                        ],
                      ),
                    );
                  } else {
                    return Text('duplicate');
                  }
                } else {
                  return Center(child: Text('No data found'));
                }
              },
            )));
  }
}
