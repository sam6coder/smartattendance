import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_attendance_system/screens/home_teacher.dart';
import 'dart:io';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:smart_attendance_system/teacherModel.dart';
import 'package:smart_attendance_system/item.dart';

class ProfileTeacherScreen extends StatefulWidget {
  ProfileTeacherScreen({super.key});
  @override
  ProfileTeacherScreenState createState() => ProfileTeacherScreenState();
}

class ProfileTeacherScreenState extends State<ProfileTeacherScreen> {
  File? profilePic;
  String rollNoS = "";
  String mobileS = "";

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('teachers');

  Future<Student> fetchStudent() async {
    DatabaseEvent event = await _dbRef.child('${username} ipec').once();

    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      return Student.fromJson(snapshot.value as Map<dynamic, dynamic>);
    } else {
      throw Exception('Student not found');
    }
  }

  late Future<Student> _studentFuture;
  List<Item> _data = [];


  void initState() {
    _studentFuture = fetchStudent();
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
            backgroundColor: Color.fromRGBO(31, 116, 206, 2),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(18, 22, 108, 2),
              automaticallyImplyLeading: false,
              title: Center(
                  child: Text(
                'Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
            ),
            body: FutureBuilder<Student>(
                future: _studentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('Student not found'));
                  } else {
                    final student = snapshot.data!;
                    _data = [
                      Item(
                        headerValue: 'Subject Code',
                        expandedValue: student.subjectCode.values.toList(),
                      ),
                      Item(
                        headerValue: 'Subject Name',
                        expandedValue: student.subjectName.values.toList(),
                      ),
                    ];

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Inderprastha Engineering College',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 25),
                            ClipRRect(
                              // borderRadius: BorderRadius.circular(0),
                              child: Image(
                                image: AssetImage('images/teacher.png'),
                                height: 170,
                                width: 250,
                              ),

                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(student.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(student.collegeEmail,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            SizedBox(height: 30),

                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text('DEPARTMENT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      )),
                                  SizedBox(height: 5),
                                  Text(student.department,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.bold)),
                                ],
                              ),
                            ),

                            SizedBox(height: 15),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: _data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleChildScrollView(
                                  child: ExpansionPanelList(
                                    animationDuration: Duration(milliseconds: 1000),
                                    dividerColor: Colors.red,
                                    elevation: 1,
                                    children: [
                                      ExpansionPanel(
                                        body:
                                        SingleChildScrollView(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _data[index].expandedValue.length,
                                            itemBuilder: (context,index1){
                                              return ListTile(

                                                  title:Text(_data[index].expandedValue[index1]),

                                              );
                                            },
                                          ),
                                        ),
                                        headerBuilder: (BuildContext context, bool isExpanded) {
                                          return Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              _data[index].headerValue,
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          );
                                        },
                                        isExpanded: _data[index].isExpanded,
                                      ),
                                    ],
                                    expansionCallback: (int item, bool status) {
                                      setState(() {
                                        _data[index].isExpanded = !_data[index].isExpanded;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            // Container(
                            //     alignment: Alignment.centerLeft,
                            //     child: Column(
                            //         crossAxisAlignment:
                            //         CrossAxisAlignment.start,
                            //         children: [
                            //           Text('Subject Code',
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 13,
                            //               )),
                            //           SizedBox(height: 5),
                            //           Text(yearS.toString(),
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 20,
                            //                   fontWeight:
                            //                   FontWeight
                            //                       .bold)),
                            //           SizedBox(height: 15),
                            //           Container(
                            //             alignment: Alignment.centerLeft,
                            //             child: Column(
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //               children: [
                            //                 Text('SECTION',
                            //                     style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: 13,
                            //                     )),
                            //                 SizedBox(height: 5),
                            //                 Text(sec,
                            //                     style: TextStyle(
                            //                         color: Colors
                            //                             .white,
                            //                         fontSize: 20,
                            //                         fontWeight:
                            //                         FontWeight
                            //                             .bold)),
                            //               ],
                            //             ),
                            //           ),
                            //           SizedBox(height: 15),
                            //           Container(
                            //             alignment: Alignment.centerLeft,
                            //             child: Column(
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //               children: [
                            //                 Text('MOBILE',
                            //                     style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: 13,
                            //                     )),
                            //                 SizedBox(height: 5),
                            //                 GestureDetector(
                            //                   behavior: HitTestBehavior
                            //                       .opaque,
                            //                   onTap: () {
                            //                     Navigator
                            //                         .pushReplacement(
                            //                       context,
                            //                       MaterialPageRoute(
                            //                         builder: (context) {
                            //                           return EditMobileScreen();
                            //                         },
                            //                       ),
                            //                     );
                            //                   },
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                     MainAxisAlignment
                            //                         .spaceBetween,
                            //                     children: [
                            //                       Text(
                            //                           mobileV
                            //                               .toString(),
                            //                           style: TextStyle(
                            //                               color: Colors
                            //                                   .white,
                            //                               fontSize: 20,
                            //                               fontWeight:
                            //                               FontWeight
                            //                                   .bold)),
                            //                       Text('>',
                            //                           style: TextStyle(
                            //                               color: Colors
                            //                                   .white,
                            //                               fontSize: 20,
                            //                               fontWeight:
                            //                               FontWeight
                            //                                   .bold)),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ])),
                          ],
                        ),
                      ),
                    );


                  }
                })));
  }
}
