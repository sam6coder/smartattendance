import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:smart_attendance_system/screens/mark_attendance.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_attendance_system/storage_repository.dart';
import 'package:smart_attendance_system/fetch.dart';
import 'face_recognised.dart';
import 'viewAttendanceTeacher.dart';
import 'face_recognised.dart';



class CameraScreen extends StatefulWidget {
  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {



late CameraController controller;

  late Future<void> initializeControllerFuture;
  @override
  void initState() {

    super.initState();

    controller = CameraController(
      CameraDescription(
          sensorOrientation: 1,
          name: '0',
          lensDirection: CameraLensDirection.back),
      ResolutionPreset.veryHigh,
    );
    initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MarkAttendanceScreen()));
      },
      child: Scaffold(
        body: AspectRatio(
          aspectRatio: 0.5,
          child: FutureBuilder<void>(
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
            future: initializeControllerFuture,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.camera_alt,
            color: Colors.black,
          ),
          onPressed: () async {
            try {
              final image = await controller.takePicture();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PreviewScreen(imagePath: image.path, file: image),
              ));
            } catch (e) {}
          },
        ),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  static StorageRepository storageRepo = StorageRepository();
  final String imagePath;
  final XFile file;



  PreviewScreen({Key? key, required this.imagePath, required this.file})
      : super(key: key);

  void upload() async {
    await storageRepo?.uploadFile(File(file.path));
  }
@override
  void initState() {

    upload();
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
          title: Text('Preview'),
        ),
        body: Column(
          children: [
            Center(
              child: Image.file(
                File(imagePath),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            ElevatedButton(
              onPressed: () async{
                upload();
                await Future.delayed(Duration(seconds: 3));
                final latestRecord = await fetchLatestData();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FaceRecognised();
                    },
                  ),
                );
              },
              child: Text('Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
