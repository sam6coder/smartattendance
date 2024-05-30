import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendance_system/screens/home_student.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:smart_attendance_system/screens/home_student.dart';
import 'dart:io';
import 'dart:developer';
import 'package:smart_attendance_system/screens/edit_name.dart';
import 'package:smart_attendance_system/screens/edit_mobile.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileStudentScreen extends StatefulWidget {
  ProfileStudentScreen({super.key});
  @override
  ProfileStudentScreenState createState() => ProfileStudentScreenState();
}

class ProfileStudentScreenState extends State<ProfileStudentScreen> {
  String rollNoS = "";
  String mobileS = "";
  String field = '';

  loadUserInfo() async {
    field = '$username ipec';
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('students/$field');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      final vals = dataSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        name = vals['Name'];
        rollNo = vals['Univ_rollno'];
        yearS = vals['Year'];
        mobileV = vals['Mobile'];
        dept = vals['Department'];
        sec = vals['Section'];


      });
    });
  }

  @override
  void initState() {
    super.initState();

    loadUserInfo();
  }

  Future<String> getData() {
    return Future.delayed(Duration(seconds: 2), () {
      return "I am data";
      // throw Exception("Custom Error");
    });
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
        backgroundColor: Color(0xFF0A0E21),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(18, 22, 108, 2),
          automaticallyImplyLeading: false,
          title: Center(
              child: Text('Profile',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: FutureBuilder(
                        builder: (ctx, snapshot) {
                          // Checking if future is resolved or not
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // If we got an error
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  '${snapshot.error} occurred',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );

                              // if we got our data
                            } else if (snapshot.hasData) {
                              final data = snapshot.data as String;
                              String imageUrl = "$rollNo ipec";

                              return Center(
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
                                        image: FirebaseImageProvider(
                                          FirebaseUrl(
                                              "gs://attendance-system-a10eb.appspot.com/student_images/$imageUrl.jpg"),
                                        ),
                                        height: 170,
                                        width: 250,
                                      ),

                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(emailS,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    SizedBox(height: 30),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('ROLL NO',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              )),
                                          SizedBox(height: 5),
                                          Text(rollNo.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
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
                                          Text(dept,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold)),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 15),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('YEAR',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  )),
                                              SizedBox(height: 5),
                                              Text(yearS.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight
                                                              .bold)),
                                              SizedBox(height: 15),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('SECTION',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                        )),
                                                    SizedBox(height: 5),
                                                    Text(sec,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('MOBILE',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                        )),
                                                    SizedBox(height: 5),
                                                    GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return EditMobileScreen();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              mobileV
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text('>',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ])),
                                  ],
                                ),
                              );
                            }
                          }

                          // Displaying LoadingSpinner to indicate waiting state
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },

                        // Future that needs to be resolved
                        // inorder to display something on the Canvas
                        future: getData(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
