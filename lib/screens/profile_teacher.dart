import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_attendance_system/screens/edit_numberTeacher.dart';
import 'package:smart_attendance_system/constants.dart';
import 'package:smart_attendance_system/screens/home_teacher.dart';

class ProfileTeacherScreen extends StatefulWidget {
  ProfileTeacherScreen({super.key});
  @override
  ProfileTeacherScreenState createState() => ProfileTeacherScreenState();
}

class ProfileTeacherScreenState extends State<ProfileTeacherScreen> {
  late Future<Map<String, dynamic>> _userInfoFuture;
  // late Future<List<String>> _subjectCodesFuture;
  late Future<List<String>> _subjectNamesFuture;

  String name = '';
  String mobile = '';
  String dept = '';
  String email = '';

  List<ExpansionItem> itemData = [];

  Future<Map<String, dynamic>> loadUserInfo() async {
    final field = '$username ipec';
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('teachers/$field');

    DatabaseEvent event = await databaseReference.once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      final vals = dataSnapshot.value as Map<dynamic, dynamic>;
      return vals.cast<String, dynamic>();
    } else {
      throw Exception('No data found');
    }
  }

  // Future<List<String>> loadSubjectCodes() async {
  //   final field = '$username ipec';
  //   DatabaseReference databaseReference =
  //       FirebaseDatabase.instance.ref().child('teachers/$field/Subject_code');
  //
  //   DatabaseEvent event = await databaseReference.once();
  //   DataSnapshot dataSnapshot = event.snapshot;
  //
  //   if (dataSnapshot.value != null) {
  //     final List<dynamic> codes = dataSnapshot.value as List<dynamic>;
  //     return codes.map((e) => e.toString()).toList();
  //   } else {
  //     return [];
  //   }
  // }

  Future<List<String>> loadSubjectNames() async {
    final field = '$username ipec';
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('teachers/$field/Subject_name');

    DatabaseEvent event = await databaseReference.once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      final List<dynamic> codes = dataSnapshot.value as List<dynamic>;
      print(dataSnapshot.value);

      return codes.map((e) => e.toString()).toList();
    } else {
      return [];
    }
  }

  Future<List<ExpansionItem>> loadExpansionItems() async {
    // Fetch the teacher ID or username dynamically as per your application logic
    // List<String> subjectCodes = await loadSubjectCodes();
    List<String> subjectNames = await loadSubjectNames();
    print(subjectNames);

    itemData = [
      ExpansionItem(
          headerValue: 'Subject Name',
          discription: subjectNames,
          names: subjectNames),
    ];

    return itemData;
  }

  late Future<List<ExpansionItem>> _expansionItemsFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = loadUserInfo();
    // loadSubjectCodes();
    loadSubjectNames();

    _expansionItemsFuture = loadExpansionItems();
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
    },child:Scaffold(
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
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            name = data['Name'] ?? '';
            mobile = data['Mobile'] ?? '';
            dept = data['Department'] ?? '';
            email = data['College_email'] ?? '';

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
                            child: Image.asset(
                              'images/teacher.png',
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
                            email,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 30),
                          _buildInfoRow('Department', dept),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('MOBILE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    )),
                                SizedBox(height: 5),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditMobileTScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(mobile,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text('>',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                itemData[index].isExpanded =
                                    !itemData[index].isExpanded;
                              });
                            },
                            children: itemData
                                .map<ExpansionPanel>((ExpansionItem item) {
                              return ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      item.headerValue,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  );
                                },
                                body: Column(
                                  children:
                                      item.discription.map<Widget>((String code) {
                                    return ListTile(
                                      title: Text(
                                        code,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                isExpanded: item.isExpanded,
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),),
    );
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

class ExpansionItem {
  ExpansionItem({
    required this.headerValue,
    required this.discription,
    required this.names,
    this.isExpanded = false,
  });

  String headerValue;
  List<String> discription;
  List<String> names;

  bool isExpanded;
}
