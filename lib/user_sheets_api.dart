//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:my_app/employee.dart';

class UserSheetsApi {
//credentials
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "appsheet-362823",
  "private_key_id": "*********************",
  "private_key": "-----BEGIN PRIVATE KEY----********************-----END PRIVATE KEY-----\n",
  "client_email": "appsheet@appsheet-362823.iam.gserviceaccount.com",
  "client_id": "106744706967040456442",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/appsheet%40appsheet-362823.iam.gserviceaccount.com"
}

''';
  static final _spreadsheetId = '1Y7MM6ztyr4Rvb_Z4k9w_REb1xM4UXZtj0Y0jgPUYtKs';

  static final gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;
  static Worksheet? _timeSheet;

  static Future init() async {
    final spreadsheet = await gsheets.spreadsheet(_spreadsheetId);
    _userSheet = await _getWorkSheet(spreadsheet, title: 'Employees');
    _timeSheet = await _getWorkSheet(spreadsheet, title: getTabName());
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    //checks if the spreadsheet exists
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static List<String> names = ['xyz'];

  static List<Employee> employees = [];

  static int currentIndex = 0;

  static List<String> datesAsEpoch = [];

  static List<String> topRow = ['Date'];
  static List<String> dates = [];

  static List<String> getNames() {
    return names;
  }

  static f(List<String> value, State state) {
    names = value;
    debugPrint("NAMES LIST: $names");

    for (int i = 0; i < names.length; i++) {
      debugPrint("entered loop to add objects");
      //debugPrint(names[i]);
      employees.add(Employee(names[i], "0:00 AM", "0:00 AM"));
      //employees[i].setName(names[i]);
      debugPrint(employees[i].toString());
      debugPrint(employees[i].name);
      debugPrint(employees[i].checkInTime);
      debugPrint(employees[i].checkOutTime);
    }

    //debugPrint("NEW LIST OF EMPLOYEE OBJECTS: $employees");

    topRow.add('Day Total');
    topRow.add('Day Pay');
    for (int i = 0; i < names.length; i++) {
      topRow.add('${names[i]} Check In');
      topRow.add('${names[i]} Check Out');
      topRow.add('${names[i]} Total Time');
      topRow.add('${names[i]} Pay');
    }

    debugPrint('$topRow');
    _timeSheet!.clearRow(1);
    _timeSheet!.values.insertRow(1, topRow);

    state.setState(() {});
  }

  static void loadNames(State state) {
    debugPrint("calling loadNames");
    Future<List<String>> n = _userSheet!.values.column(1, fromRow: 2);
    n.then((value) => f(value, state));
  }

  static void g(List<String> value, State state) {
    datesAsEpoch = value;
    state.setState(() {});

    debugPrint("dates are $datesAsEpoch");
    epochToString();
    debugPrint("Dates converted from epoch to datetime to string $dates");
  }

  static void loadDates(State state) {
    debugPrint("calling loadDates");
    //Future<List<String>> formattedDates = [] as Future<List<String>>;
    Future<List<String>> d = _timeSheet!.values.column(1, fromRow: 2);

    d.then((value) => g(value, state));
  }

  static void epochToString() {
    var epoch = DateTime(1899, 12, 30);
    for (int i = 0; i < datesAsEpoch.length; i++) {
      var dateToInt = int.parse(datesAsEpoch[i]);
      var currentDate = epoch.add(new Duration(days: dateToInt));

      dates.add(DateFormat.yMd().format(currentDate));
    }
  }

  static String getCurrentHourMin() {
    final currentTime = DateTime.now();
    return DateFormat.jm().format(currentTime);
  }

  static String getMonthDayYear() {
    final currentTime = DateTime.now();
    return DateFormat.yMd().format(currentTime);
  }

  static String dateDisplay() {
    final currentTime = DateTime.now();
    return DateFormat.yMMMd().format(currentTime);
  }

  static String getTabName() {
    final currentTime = DateTime.now();
    return DateFormat.yMMM().format(currentTime);
  }

  static void insertClockIn() {
    debugPrint(getTabName());
    debugPrint("dates length: ${datesAsEpoch.length}");
    for (int i = 0; i < datesAsEpoch.length; i++) {
      var currentMonthDayYear = getMonthDayYear();
      debugPrint(getMonthDayYear());
      if (dates[i] == currentMonthDayYear) {
        debugPrint(dates[i]);
        int currentDateIndex = i;
        debugPrint('${names[currentIndex]} current name pressed $currentIndex');
        var rowIndexName = topRow.indexOf('${names[currentIndex]} Check In');
        debugPrint('$rowIndexName');
        employees[getCurrentIndex()].checkInTime = getCurrentHourMin();
        debugPrint(
            "check in time from employee class: ${employees[getCurrentIndex()].checkInTime}");

        _timeSheet!.values.insertValue(getCurrentHourMin(),
            column: rowIndexName + 1, row: currentDateIndex + 2);
        employees[getCurrentIndex()].isClockedIn = true;
        //debugPrint(
        //  "is clocked in? ${employees[getCurrentIndex()].isClockedIn}");
      }
    }
  }

  static void insertClockOut() {
    for (int i = 0; i < datesAsEpoch.length; i++) {
      if (dates[i] == getMonthDayYear()) {
        debugPrint(dates[i]);
        int currentDateIndex = i;
        debugPrint('${names[currentIndex]} current name pressed $currentIndex');
        var rowIndexName = topRow.indexOf('${names[currentIndex]} Check Out');
        debugPrint('$rowIndexName');
        employees[getCurrentIndex()].checkOutTime = getCurrentHourMin();
        debugPrint(
            "check out time from employee class: ${employees[getCurrentIndex()].checkOutTime}");
        _timeSheet!.values.insertValue(getCurrentHourMin(),
            column: rowIndexName + 1, row: currentDateIndex + 2);
        employees[getCurrentIndex()].isClockedOut = true;
        debugPrint(
            "is clocked out? ${employees[getCurrentIndex()].isClockedOut}");
      }
    }
  }

  static void passCurrentIndex(var index) {
    //debugPrint("current index is: $index");
    currentIndex = index;
  }

  static int getCurrentIndex() {
    return currentIndex;
  }
}
