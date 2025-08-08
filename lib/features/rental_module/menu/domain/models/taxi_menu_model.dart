import 'package:flutter/material.dart';

class TaxiMenuModel {
  String icon;
  String title;
  dynamic route;
  bool isBlocked;
  bool isNotSubscribe;
  bool isLanguage;
  Color? iconColor;

  TaxiMenuModel({required this.icon, required this.title, required this.route, this.isBlocked = false, this.isNotSubscribe = false, this.iconColor, this.isLanguage = false});
}