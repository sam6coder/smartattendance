import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_system/screens/home_student.dart';
import 'package:smart_attendance_system/screens/home_teacher.dart';
import 'screens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:developer';
import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/select.dart';
import 'package:get/get.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

late SharedPreferences prefs;

Future<void> _configureAmplify() async{

  try {
    await Amplify.addPlugins([
      AmplifyStorageS3(),
      AmplifyAuthCognito(),

    ]);
    await Amplify.configure(amplifyconfig);

  }catch(e){
    print(e);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras=await availableCameras();
  final firstCamera=cameras.first;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _configureAmplify();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}
class MyAppState extends State<MyApp>{

  bool isAmplifyConfigured=false;

  @override
  void initState(){
    super.initState();

  }

  final AuthService _authService=AuthService();

  //const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? start=prefs.getString('logged in');
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          useMaterial3: true,
        ),
        //home: (FirebaseAuth.instance.currentUser==null)?SplashScreen():isS,
        home: (FirebaseAuth.instance.currentUser!=null)?start!=null?start=="login_student"?HomeStudentScreen():HomeTeacherScreen():SplashScreen():SplashScreen(),



        );
    }

}
