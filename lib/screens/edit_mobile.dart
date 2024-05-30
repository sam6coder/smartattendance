import 'package:flutter/material.dart';
import 'package:smart_attendance_system/screens/profile_student.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:developer';

class EditMobileScreen extends StatefulWidget {
  @override
  EditMobileScreenState createState() => EditMobileScreenState();
}

class EditMobileScreenState extends State<EditMobileScreen> {
  TextEditingController mobileController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading=false;
  late User user;
  String mobile = "";
  bool bioValid=true;
  bool displayNumberValid=true;
  final nameFocusNode = FocusNode();
  TextEditingController nameController=TextEditingController();

  void editName() async {
    mobile = mobileController.text.trim();

    if (mobile== "" || mobile.length<10) {
      displayNumberValid=true;

      Fluttertoast.showToast(
        msg: 'Please enter a valid number',
        toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFF3E5F5),
          textColor: Colors.black
      );
    } else {
      try {
        await FirebaseFirestore.instance.collection('students').doc(
            "$username ipec").update({"Mobile_number": "$mobileController"});
      } on FirebaseAuthException catch (ex) {
        if (ex.code == "weak-password") {
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
  // updateProfileData() async {
  //   name = nameController.text.trim();
  //
  //   setState(() {
  //     nameController.text.trim().length<3 || nameController.text.isEmpty?displayNameValid=false:displayNameValid=true;
  //
  //   });
  //   if(displayNameValid){
  //     await FirebaseFirestore.instance.collection('students').doc(
  //         "$username ipec").update({"Name": "$nameController"});
  //     SnackBar snackbar=SnackBar(content: Text("Profile updated"));
  //     scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text("Profile updated")));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    editName();
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
          key:scaffoldKey,

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
                            constraints: BoxConstraints.tight(const Size(365, 43)),
                            child: Obx(()=>TextFormField(
                              initialValue: "$mobile.value",
                              focusNode: nameFocusNode,
                              keyboardType: TextInputType.text,
                              controller: nameController,
                              decoration: InputDecoration(
                                //errorText: displayNameValid?null:"Mobile number should be 10 digits",
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                fillColor: Color(0xFFccb9f7),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintText: '$mobile.value',
                              ),
                            ),
                            ),),
                          TextButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(330,50)),
                              backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF651FFF),),),
                            onPressed: (){
                              editName();
                            }, child: Text('Save Mobile',style:TextStyle(color:Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),),
                        ],
                      ),
                    ),
                  ]),
                )),
          )),
    );
  }
}


