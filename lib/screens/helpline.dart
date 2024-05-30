import 'home_student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_attendance_system/item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_attendance_system/place.dart';
import 'package:map_launcher/map_launcher.dart';

class HelplineScreen extends StatefulWidget{
  @override
  HelplineScreenState createState()=>HelplineScreenState();
}

class HelplineScreenState extends State<HelplineScreen>{

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
      headerItem: 'National Emergency Services',
      discription:
      ['National Emergency Number','AIDS Helpline','Disaster Management','Railway','Cyber Crime Helpline','Tourist Helpline','Medical Helpline','Road Accident Emergency Service','Railway Accident Emergency Service'],
      numbers: ['112','1097','1078','139','15620','1363','108','1073','1072'],
      icons: [Icons.call,Icons.medical_information,Icons.severe_cold,Icons.directions_railway,Icons.laptop,Icons.snowboarding,Icons.medical_services_outlined,Icons.add_road,Icons.railway_alert],
      colors: [Colors.black87,Colors.red,Colors.lightBlueAccent,Colors.yellow,Colors.pink,Colors.orange,Colors.red,Colors.green,Colors.lightBlue],
    ),

    ItemModel(
        headerItem: 'UP Emergency Service Numbers',
        discription:['Fire and Rescue','Police','Covid Helpline','C.M. Helpline','State Helpline','Women Helpline','Disaster Management'],
        numbers: ['101','100','18001805145','05222239296','05222838128','1090','9711077372'],
        icons: [Icons.fire_extinguisher,Icons.local_police_rounded,Icons.masks,Icons.person,Icons.help_center_outlined,Icons.woman,Icons.thunderstorm_outlined,],
        colors:[Colors.deepOrange,Colors.lightGreen,Colors.lightBlueAccent,Colors.red,Colors.blueGrey,Colors.pink,Colors.lightGreenAccent]
    ),

  ];
  List<PlaceModel> placeData=<PlaceModel>[
    PlaceModel(
      headerItem: 'Metro Station',
      discription: ['Vaishali Metro Station','Kaushambi Metro Station','Raj Bagh Metro Station'],
      latitude: [28.649947,28.645523,28.677031],
      longitude: [77.339711,77.324297,77.346578],
      icons: [Icons.directions_railway,Icons.directions_railway,Icons.directions_railway],
      colors: [Colors.blue,Colors.red,Colors.red],
    ),
    PlaceModel(
        headerItem: 'Airport',
        discription: ['Indira Gandhi International Airport','Hindon Airport'],
        latitude: [28.568611,28.70579],
        longitude: [77.112222,77.342137],
        icons: [Icons.airplanemode_on_outlined,Icons.airplanemode_on_sharp],
        colors: [Colors.lightBlueAccent,Colors.lightGreenAccent]),
    PlaceModel(
        headerItem: 'Railway Station',
        discription: ['Ghaziabad Junction Railway Station','Sahibabad Junction Railway Station','Anand Vihar Terminal Railway Station'],
        latitude: [28.6505,28.6742,28.650775],
        longitude: [77.4318,77.3645,77.315239],
        icons: [Icons.directions_railway,Icons.directions_railway_filled_outlined,Icons.directions_railway_filled_rounded],
        colors: [Colors.yellow,Colors.redAccent,Colors.orange]),
    PlaceModel(headerItem: 'Rapid Rail',
        discription: ['Delhi–Meerut Regional Rapid Transit System'],
        longitude: [77.4139],
        latitude: [28.6724],
        icons:[Icons.directions_railway_filled_rounded],
        colors: [Colors.pink]),
    PlaceModel(
        headerItem: 'Bus Station',
        discription: ['Anand Vihar ISBT','Vaishali Bus Stand','Old Bus Stand, Ghaziabad'],
        longitude: [77.316111,77.317128,77.431217],
        latitude: [28.647222,28.644513,28.670256],
        icons: [Icons.directions_bus,Icons.directions_bus_outlined,Icons.directions_bus_filled_outlined],
        colors: [Colors.purple,Colors.deepPurpleAccent,Colors.deepPurple])

  ];
  List<PlaceModel> medicalData= <PlaceModel>[
    PlaceModel(
        headerItem: 'Nearby Hospitals',
        discription:['Max Super Speciality Hospital','Yashoda Super Speciality Hospital','Columbia Asia Hospital','Santosh Hospital'
            ''
            ';'] ,
        longitude: [77.3331,77.3287,77.4287,77.4322],
        latitude: [28.6346,28.6448,28.6696,28.6698],
        icons: [Icons.local_hospital,Icons.local_hospital_outlined,Icons.local_hospital_sharp,Icons.local_hospital_outlined],
        colors: [Colors.red,Colors.pinkAccent,Colors.deepOrange,Colors.orange])
  ];

  bool active = false;


  canLauncher(String number) async{
    var url='tel:$number';
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url),);
    }else{
      throw 'error_not_launch'+'$url';
    }
  }

  canlaunchMap(double lat,double long) async{
    // Uri url2=Uri(scheme: 'https', host: 'www.google.com/maps', path: '?q=$lat,$long');
    String url = 'https://www.google.com/maps?q=$lat,$long';
    final encodedQuery = Uri.encodeComponent('$lat,$long');

    final String encodedURl = Uri.encodeFull(url);


    var isAvailable = await MapLauncher.isMapAvailable(MapType.google);

    if (isAvailable == true) {
      await MapLauncher.showDirections(
        mapType: MapType.google,
        destination: Coords(lat,long),
        originTitle: "Shanghai Tower",
      );
    }

  }


  @override
  Widget build(BuildContext context){
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
      if (didPop) {
        return;
      }

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeStudentScreen()));
    },child:Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18,22,108,2),
        automaticallyImplyLeading: false,
        title: Center(child: Text('Student Resources',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),)),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text('Helpline Numbers',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: itemData.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: ExpansionPanelList(
                      animationDuration: Duration(milliseconds: 1000),
                      dividerColor: Colors.red,
                      elevation: 1,
                      children: [
                        ExpansionPanel(
                          body:
                          SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: itemData[index].discription.length,
                              itemBuilder: (context,index1){
                                return ListTile(
                                    leading: Icon(itemData[index].icons[index1],color: itemData[index].colors[index1],),
                                    title:Text(itemData[index].discription[index1]),
                                    onTap:()=>canLauncher(itemData[index].numbers[index1])
                                );
                              },
                            ),
                          ),
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                itemData[index].headerItem,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            );
                          },
                          isExpanded: itemData[index].expanded,
                        ),
                      ],
                      expansionCallback: (int item, bool status) {
                        setState(() {
                          itemData[index].expanded = !itemData[index].expanded;
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),


              Container(
                child: Text("Transportation Services",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: placeData.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: ExpansionPanelList(
                      animationDuration: Duration(milliseconds: 1000),
                      dividerColor: Colors.red,
                      elevation: 1,
                      children: [
                        ExpansionPanel(
                          body:

                          SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: placeData[index].discription.length,
                              itemBuilder: (context,index1){
                                return ListTile(
                                  leading: Icon(placeData[index].icons[index1],color: placeData[index].colors[index1],),
                                  title:Text(placeData[index].discription[index1]),
                                  onTap:()=>canlaunchMap(placeData[index].latitude[index1],placeData[index].longitude[index1]),

                                );
                              },
                            ),
                          ),
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                placeData[index].headerItem,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            );
                          },
                          isExpanded: placeData[index].expanded,
                        )
                      ],
                      expansionCallback: (int item, bool status) {
                        setState(() {
                          placeData[index].expanded = !placeData[index].expanded;
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                child: Text('Medical Services',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: medicalData.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: ExpansionPanelList(
                      animationDuration: Duration(milliseconds: 1000),
                      dividerColor: Colors.red,
                      elevation: 1,
                      children: [
                        ExpansionPanel(
                          body:
                          SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: medicalData[index].discription.length,
                              itemBuilder: (context,index1){
                                return ListTile(
                                    leading: Icon(medicalData[index].icons[index1],color: medicalData[index].colors[index1],),
                                    title:Text(medicalData[index].discription[index1]),
                                    onTap:()=>canlaunchMap(medicalData[index].latitude[index1],medicalData[index].longitude[index1])
                                );
                              },
                            ),
                          ),
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                medicalData[index].headerItem,
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            );
                          },
                          isExpanded: medicalData[index].expanded,
                        )
                      ],
                      expansionCallback: (int item, bool status) {
                        setState(() {
                          medicalData[index].expanded = !medicalData[index].expanded;
                        });
                      },
                    ),
                  );
                },
              ),


            ],
          ),
        ),
      ),
    ),
    );
  }
}