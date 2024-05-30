import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceModel {
  bool expanded;
  String headerItem;
  List<String> discription;

  List<double> latitude;
  List<double> longitude;
  List<IconData> icons;
  List<Color> colors;

  PlaceModel({this.expanded=false,required this.headerItem, required this.discription,required this.longitude,required this.latitude,required this.icons,required this.colors});
}