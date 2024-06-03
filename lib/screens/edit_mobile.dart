import 'package:flutter/material.dart';
import 'package:smart_attendance_system/screens/profile_student.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';

class EditMobileScreen extends StatefulWidget {
  @override
  EditMobileScreenState createState() => EditMobileScreenState();
}

class EditMobileScreenState extends State<EditMobileScreen> {
  TextEditingController mobileController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  late User user;
  String mobile = "";
  bool bioValid = true;
  bool displayNumberValid = true;
  final numberFocusNode = FocusNode();



  void editNumber() async {
    mobile = mobileController.text.trim();

    if (mobile == "" || mobile.length != 10) {
      //displayNumberValid = true;

      Fluttertoast.showToast(
          msg: 'Please enter a valid number',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFF3E5F5),
          textColor: Colors.black);
    } else {
      try {
        Map<String, dynamic> newUserData = {"Mobile": mobile};
        FirebaseDatabase database = FirebaseDatabase.instance;
        DatabaseReference ref = database.ref("students/$username ipec");
        await ref.update({"Mobile": mobile});

        await FirebaseFirestore.instance
            .collection("students")
            .doc("$username ipec")
            .update(newUserData);
        Fluttertoast.showToast(
            msg: 'Mobile Number Changed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xFFF3E5F5),
            textColor: Colors.black);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ProfileStudentScreen()));
      } on FirebaseAuthException catch (ex) {
        if (ex.code == "failed") {
          //snackbar
        }
        log(ex.code.toString());
      }
    }
  }

  loadUserInfo() async {
    mobileVd.value = await FirebaseFirestore.instance
        .collection('students')
        .doc("$username ipec")
        .get()
        .then((value) {
      return value.get('Mobile_number');
    });
  }

  @override
  void dispose() {
    super.dispose();
    mobileController.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadUserInfo();
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
            MaterialPageRoute(builder: (context) => ProfileStudentScreen()));
      },
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Color.fromRGBO(31, 116, 206, 2),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(18, 22, 108, 2),
            automaticallyImplyLeading: false,
            title: Center(
                child: Text('Edit Mobile Number',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(children: [
                Text(
                  'MOBILE NUMBER',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MOBILE NUMBER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          )),
                      SizedBox(height: 5),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(const Size(365, 50)),
                        child: TextFormField(
                          focusNode: numberFocusNode,
                          keyboardType: TextInputType.number,
                          controller: mobileController,
                          decoration: InputDecoration(
                            fillColor: Color(0xFFccb9f7),
                            hintText: 'Enter your new Number',
                            icon: Icon(Icons.contact_page_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length!=10) {
                              numberFocusNode.requestFocus();
                              return 'Please enter a valid phone number';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: TextButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(330, 50)),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              Color(0xFF651FFF),
                            ),
                          ),
                          onPressed: () {
                            editNumber();
                          },
                          child: Text('Save Mobile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            )),
          )),
    );
  }
}
