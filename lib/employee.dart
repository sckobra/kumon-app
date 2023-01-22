import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class Employee {
  String name = "";
  String checkInTime = "";
  String checkOutTime = "";
  bool isClockedIn = false;
  bool isClockedOut = false;

//CONSTRUCTOR

  Employee(this.name, this.checkInTime, this.checkOutTime);

//SET METHOD
  void setName(String name) {
    this.name = name;
    debugPrint("SET NAME CALLED");
  }

  String getName() {
    return name;
  }

  @override
  String toString() {
    return "Name: $name, Checked In At: $checkInTime, Checked Out At: $checkOutTime";
  }
}
