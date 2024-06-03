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

import 'package:smart_attendance_system/screens/edit_mobile.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileStudentScreen extends StatefulWidget {


  ProfileStudentScreen({super.key});
  @override
  ProfileStudentScreenState createState() => ProfileStudentScreenState();
}

class ProfileStudentScreenState extends State<ProfileStudentScreen> {
  late Future<Map<String, dynamic>> _userInfoFuture;

  String rollNoS = "";
  String mobileS = "";
  String field = '';

  Future<Map<String, dynamic>> loadUserInfo() async {
    final field = '$username ipec';
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('students/$field');

    DatabaseEvent event = await databaseReference.once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      final vals = dataSnapshot.value as Map<dynamic, dynamic>;

      return vals.cast<String, dynamic>();
    } else {
      throw Exception('No data found');
    }
  }
  // loadUserInfo() async {
  //   field = '$username ipec';
  //   DatabaseReference databaseReference =
  //       FirebaseDatabase.instance.ref().child('students/$field');
  //
  //   databaseReference.onValue.listen((event) {
  //     DataSnapshot dataSnapshot = event.snapshot;
  //
  //     final vals = dataSnapshot.value as Map<dynamic, dynamic>;
  //     setState(() {
  //       name = vals['Name'];
  //       rollNo = vals['Univ_rollNo'];
  //       yearS = vals['Year'];
  //       mobileV = vals['Mobile'];
  //       dept = vals['Department'];
  //       sec = vals['Section'];
  //
  //
  //     });
  //   });
  // }

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
    print(username);
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
          body: FutureBuilder<Map<String, dynamic>>(
            future: loadUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                final name = data['Name'] ?? '';
                final rollNo = data['Univ_rollNo'] ?? '';
                final yeard = data['Year'] ?? '';
                final mobiled = data['Mobile'] ?? '';
                final dept = data['Department'] ?? '';
                final secd = data['Section'] ?? '';
                final mail=data['College_email']??'';


                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
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
                                child: Image(
                                  image: FirebaseImageProvider(
                                    FirebaseUrl(
                                        "gs://attendance-system-a10eb.appspot.com/student_images/$rollNo ipec.jpg"),
                                  ),
                                  height: 170,
                                  width: 170,
                                ),


                              ),
                              SizedBox(height: 15),

                              Text(
                                name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                mail,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(height: 30),
                              _buildInfoRow('Roll No', rollNo),
                              SizedBox(
                                height: 10,
                              ),
                              _buildInfoRow('Department', dept),
                              SizedBox(
                                height: 10,
                              ),
                              _buildInfoRow('Year', yeard),
                              SizedBox(
                                height: 10,
                              ),
                              _buildInfoRow('Section', secd),
                              SizedBox(
                                height: 10,
                              ),
                              // _buildInfoRow('Mobile', mobiled),

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
                                    mobiled
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
                          ),],),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text('No data found',style: TextStyle(color: Colors.white),));
              }
            },
          ),
        ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        alignment: Alignment.centerLeft,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
