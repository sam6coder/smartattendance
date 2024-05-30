import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_attendance_system/fetch.dart';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:smart_attendance_system/fetch.dart';
import 'package:smart_attendance_system/attendanceModel.dart';
import 'package:intl/intl.dart';
import 'package:smart_attendance_system/screens/camera_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';


class FaceRecognised extends StatefulWidget {
  @override
  FaceRecognisedState createState() => FaceRecognisedState();
}

class FaceRecognisedState extends State<FaceRecognised> {
  late Future<AttendanceRecord> latestAttendanceRecords;

  void initState() {
    super.initState();
    latestAttendanceRecords = fetchLatestData();

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

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CameraScreen()));
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(18, 22, 108, 2),
              automaticallyImplyLeading: false,
              title: Center(
                  child: Text(
                'View Attendance',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )),
            ),
            body: FutureBuilder<AttendanceRecord>(
              future: fetchLatestData(),
              builder: (BuildContext context,
                  AsyncSnapshot<AttendanceRecord> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  AttendanceRecord record = snapshot.data!;
                  DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                      .parse(record.timestamp);
                  DateTime now = DateTime.now();
                  DateTime recordTime = DateTime.parse(record.timestamp);

                  Duration difference = now.difference(recordTime);
                  bool isRecognized = difference.inSeconds < 3;

                  if (isRecognized) {
                    String uni = record.uniRollNumber.toString();

                    String imageUrl = uni + ' ipec';

                    return Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.9,
                        color: Colors.cyan[100],
                        child: Padding(
                          padding: EdgeInsets.all(43),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(
                                    Icons.task_alt_outlined,
                                    color: Colors.green[900],
                                    size: 35,
                                  ),
                                  Text(
                                    'Marked Present',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(210),
                                child: Image(
                                  image: FirebaseImageProvider(
                                    FirebaseUrl(
                                        "gs://attendance-system-a10eb.appspot.com/student_images/$imageUrl.jpg"),
                                  ),
                                  height: 250,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              AutoSizeText(
                                  '${record.firstName} ${record.lastName}',

                                style: TextStyle(fontSize: 30,color: Colors.blue[900],fontWeight: FontWeight.bold), // Base font size
                                maxLines: 1, // Maximum number of lines
                                overflow: TextOverflow.ellipsis, // Handle overflow
                                textAlign: TextAlign.center, // Center align the text
                              ),
                                                            SizedBox(
                                height: 6,
                              ),
                              AutoSizeText(
                                'Total Present Days: ${record.totalPresentDays}',
                                style: TextStyle(fontSize: 20,      fontWeight: FontWeight.bold), // Base font size
                                maxLines: 2, // Maximum number of lines
                                overflow: TextOverflow.ellipsis, // Handle overflow
                                textAlign: TextAlign.center, // Center align the text
                              ),


                              SizedBox(
                                height: 6,
                              ),
                              AutoSizeText(
                                'Total Working Days: ${record.totalWorkingDays}',
                                style: TextStyle(fontSize: 20,      fontWeight: FontWeight.bold), // Base font size
                                maxLines: 2, // Maximum number of lines
                                overflow: TextOverflow.ellipsis, // Handle overflow
                                textAlign: TextAlign.center, // Center align the text
                              ),

                              SizedBox(
                                height: 6,
                              ),
                              AutoSizeText(
                                'Previous Attendance Date: ${record.previousAttendanceDate}',
                                style: TextStyle(fontSize: 20,      fontWeight: FontWeight.bold), // Base font size
                                maxLines: 2, // Maximum number of lines
                                overflow: TextOverflow.ellipsis, // Handle overflow
                                textAlign: TextAlign.center, // Center align the text
                              ),

                              SizedBox(
                                height: 6,
                              ),
                              AutoSizeText(
                                'Timestamp: ${record.timestamp.toString()}',
                                style: TextStyle(fontSize: 20,      fontWeight: FontWeight.bold), // Base font size
                                maxLines: 2, // Maximum number of lines
                                overflow: TextOverflow.ellipsis, // Handle overflow
                                textAlign: TextAlign.center, // Center align the text
                              ),


                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        color: Colors.cyan[200],
                        child: Column(
                          children: [
                            Text(
                              'Face not registered in database ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Contact admin',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(child: Text('No data found'));
                }
              },
            )));
  }
}
