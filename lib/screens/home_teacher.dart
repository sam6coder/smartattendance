import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_system/screens/login_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:smart_attendance_system/screens/profile_teacher.dart';
import 'package:smart_attendance_system/screens/mark_attendance.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:smart_attendance_system/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_attendance_system/screens/viewAttendanceTeacher.dart';
import 'package:smart_attendance_system/screens/profile_teacher.dart';

class HomeTeacherScreen extends StatefulWidget {
  HomeTeacherScreen({super.key});
  @override
  HomeTeacherScreenState createState() => HomeTeacherScreenState();
}

class HomeTeacherScreenState extends State<HomeTeacherScreen> {
  // String email = "";
  // String username = "";
  File? profilePic;
  String field='';


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
    await prefs.setString("usernameM", username);

    field = '$username ipec';
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref().child('teachers/$field');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;

      final vals = dataSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        name = vals['Name'];

      });
    });



  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("logged in");
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginTeacherScreen()));
  }

  @override
  void initState() {
    super.initState();

    loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 116, 206, 2),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18,22,108,2),
        automaticallyImplyLeading: false,
        title: Center(child: Text('Home',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),)),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(Icons.exit_to_app,color:Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

            Container(
              alignment: Alignment.topLeft,
              child: Text('Hello',
                  style: TextStyle(
                      fontSize: 25,
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
            SizedBox(
              height: 90,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MarkAttendanceScreen();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Image.asset('images/mark.webp',height:150,width:150),

                              Column(
                                children: [
                                  Text(
                                    'Mark',
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  Text(
                                    'Attendance',
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AttendanceScreen();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Image.asset('images/view.png',height:150,width:150),

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

                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfileTeacherScreen();
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Image.asset('images/teacher.png',height:150,width:150),

                          Text(
                            'Profile',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),

                        ],
                      ),
                    ),
                  ),



                ],
              ),
            ),

          ],
        ),),

    );
  }
}
