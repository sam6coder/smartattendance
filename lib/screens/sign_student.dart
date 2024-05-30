import 'package:flutter/material.dart';
import 'package:smart_attendance_system/screens/login_student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_attendance_system/screens/select.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:firebase_database/firebase_database.dart';


class SignStudentScreen extends StatefulWidget {
  SignStudentScreen({super.key});
  @override
  SignStudentScreenState createState() => SignStudentScreenState();
}

class SignStudentScreenState extends State<SignStudentScreen> {
  FocusNode myfocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  TextEditingController numberController = TextEditingController();
  final numberFocusNode = FocusNode();
  TextEditingController univRollController = TextEditingController();
  final univRollFocusNode = FocusNode();
  var isObscured;
  String extractUsernameFromEmail(String email) {
    List<String> parts = email.split('@');
    if (parts.length == 2) {
      return parts[0];
    } else {
      throw FormatException('Invalid email format');
    }
  }


  void createAccount() async {
    emailS = emailController.text.trim();
    name = nameController.text.trim();
    String password = passwordController.text.trim();
    univRoll=univRollController.text.trim();
    phone=numberController.text.trim();

    username = extractUsernameFromEmail(emailS);
    print('Username: $username');

    if (emailS == "" || password == "" || name == "" || univRoll=="" || phone=="" ) {
      Fluttertoast.showToast(
          msg: 'Please fill all the fields',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFF3E5F5),
          textColor: Colors.black
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: emailS, password: password);
        Map<String, dynamic> newUserData = {"password": "$password","Mobile":"$phone","Univ_rollNo":"$univRoll"};
        FirebaseDatabase database = FirebaseDatabase.instance;
        DatabaseReference ref = database.ref("students/$username ipec");
        await ref.update({
          "Password": password,
          "Mobile":"$phone","Univ_rollNo":"$univRoll"

        });

        await FirebaseFirestore.instance
            .collection("students")
            .doc("$username ipec")
            .update(newUserData);
        if (userCredential.user != null) {
          Navigator.pop(context);
        }
        log("User created");
      } on FirebaseAuthException catch (ex) {
        if (ex.code == "weak-password") {
          //snackbar
        }
        log(ex.code.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isObscured = true;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop)async{
        if(didPop){
          return;
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SelectScreen()));

      },
      child: Scaffold(
        appBar: AppBar(

        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Text('Sign Up',
                          style: TextStyle(
                              fontSize: 60,
                              color: Color(0xFF651FFF),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(const Size(365, 50)),
                        child: TextFormField(
                          focusNode: nameFocusNode,
                          keyboardType: TextInputType.name,
                          controller: nameController,
                          decoration: InputDecoration(
                            fillColor: Color(0xFFccb9f7),
                            hintText: 'Enter your Name',
                            icon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              nameFocusNode.requestFocus();
                              return 'Please enter your name';
                            }
                          },
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(const Size(365, 50)),
                        child: TextFormField(
                          focusNode: emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: Color(0xFFccb9f7),
                            hintText: 'Enter your College Email-Id',
                            icon: Icon(Icons.mail),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              emailFocusNode.requestFocus();
                              return 'Please enter an email';
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(const Size(365, 50)),
                        child: TextFormField(
                          obscureText: isObscured,
                          focusNode: passwordFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: 'Enter your Password',
                            icon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              padding: EdgeInsetsDirectional.only(end: 12.0),
                              icon: isObscured
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isObscured = !isObscured;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              passwordFocusNode.requestFocus();
                              return 'Please enter some text';
                            }
                            if (value.length < 6) {
                              passwordFocusNode.requestFocus();
                              return 'Password must be atleast 6 characters';
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(const Size(365, 50)),
                        child: TextFormField(
                          focusNode: numberFocusNode,
                          keyboardType: TextInputType.number,
                          controller: numberController,
                          decoration: InputDecoration(
                            fillColor: Color(0xFFccb9f7),
                            hintText: 'Enter your Number',
                            icon: Icon(Icons.contact_page_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              nameFocusNode.requestFocus();
                              return 'Please enter your phone number';
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints.tight(const Size(365, 50)),
                        child: TextFormField(
                          focusNode: univRollFocusNode,
                          keyboardType: TextInputType.number,
                          controller: univRollController,
                          decoration: InputDecoration(
                            fillColor: Color(0xFFccb9f7),
                            hintText: 'Enter your University RollNo',
                            icon: Icon(Icons.contact_page_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              nameFocusNode.requestFocus();
                              return 'Please enter your University RollNo';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(330, 50)),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              Color(0xFF651FFF),
                            ),
                          ),
                          onPressed: () {
                            createAccount();
                            Fluttertoast.showToast(
                                msg: 'Account created',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Color(0xFFF3E5F5),
                                textColor: Colors.black
                            );


                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginStudentScreen()),
                            );
                          },
                          child: Text('Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),

      //fillColor: Color(0xFF7E57C2),
      ),
    );
  }
}
