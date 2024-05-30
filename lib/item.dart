import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemModel {
  bool expanded;
  String headerItem;
  List<String> discription;

  List<String> numbers;
  List<IconData> icons;
  List<Color> colors;

  ItemModel({this.expanded= false,required this.headerItem, required this.discription,required this.numbers,required this.icons,required this.colors});
}

class Item {
  Item({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });

  String headerValue;
  List<String> expandedValue;
  bool isExpanded;
}