import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendance_system/firebase_service.dart';
import 'package:smart_attendance_system/screens/login_student.dart';
import 'dart:developer';
import 'package:smart_attendance_system/screens/profile_student.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:smart_attendance_system/firebase_service.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'helpline.dart';
import 'package:smart_attendance_system/screens/viewAttendanceStudent.dart';

class HomeStudentScreen extends StatefulWidget {
  HomeStudentScreen({super.key});
  @override
  HomeStudentScreenState createState() => HomeStudentScreenState();
}

class HomeStudentScreenState extends State<HomeStudentScreen> {
  File? profilePic;

  List<String> items = ['DAA', 'DS', 'COA', 'CD', 'OS', 'DBMS', 'TAFL'];
  String? selectedItem = 'DAA';
  String? imageUrl;
  String name = '';
  String field = '';
  // DatabaseReference child=refd.child("Name");

  // FirebaseDatabase database = FirebaseDatabase.instance;

  final allPaper = <String>[].obs;

  String extractUsernameFromEmail(String email) {
    List<String> parts = email.split('@');
    if (parts.length == 2) {
      return parts[0];
    } else {
      throw FormatException('Invalid email format');
    }
  }

  loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailS = (prefs.getString('username') ?? "");
    username = extractUsernameFromEmail(emailS);
    field = '$username ipec';
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('students/$field');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      final vals = dataSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        name = vals['Name'];

      });
    });


  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginStudentScreen()));
  }

  Future<String> getData() {
    return Future.delayed(Duration(seconds: 2), () {
      return "I am data";
      // throw Exception("Custom Error");
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }



  @override
  Widget build(BuildContext context) {
    // QuestionPaper questionPaperController = Get.find();
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 116, 206, 2),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 22, 108, 2),
        automaticallyImplyLeading: false,
        title: Text('Dashboard',style:TextStyle(color:Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(

              alignment: Alignment.topLeft,
              child: const Text('Hello',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),

            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Text(
                name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewAttendanceStudentScreen();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Image.asset('images/mark.webp',
                                  height: 150, width: 150),
                              // Icon(
                              //   Icons.assignment_ind_outlined,
                              //   size: 70,
                              //   //color: Color.fromRGBO(255, 153, 204, 2)
                              //   color:Colors.black,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    'View',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  Text(
                                    'Attendance',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HelplineScreen();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Image.asset('images/pwde.png',
                                  height: 120, width: 120),
                              Column(
                                children: [

                                  Text(
                                    'Resources',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfileStudentScreen();
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Image.asset('images/qwet.png',
                                height: 150, width: 150),
                            Text(
                              'Profile',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
