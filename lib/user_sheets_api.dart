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
  "private_key_id": "1892bab6a5ddb40cb9ab7310ec5f841d9066fa6d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDUgPFEgImtHxDq\nfX2WDhhvYAvBva7LpDZb7Ggh3i7grVwk+L0WyGoIM4O0PtWc99VufHiuc3h2kdlS\n4YnxL0YwGgu59oEPB2eTwwpg7QamcQaH6a5u/m76a7+vM5prmoo/8fJx0Is5bJ/+\n1NUU8FbOJ/sVwDzuDrF43ciiAq1n6jM0npN5X/eFJXGHZkTt9z5sXpbWVEg4okUt\nghfmkOniQjQ693owh/OnhaPwi9wtSPXlLMfW2PzpCEksUzEx0iTF+RmcZMY4m9yq\nMDt16zYE/ZFN1OEdU4HPrqI5YYeUcOFccwlTnNBubY/eale3PAfEwDcO+PJiL8Fx\ncdk1oQb/AgMBAAECggEAC1hdyS1fOSEGxN++emocb6gxW7G2HDgs3ZTn04fdrKNR\nkpKKSD+aumWQFNAjLm/kcxm6uOTNG/BAdomeodCtm7htEAuzKzhXFTWQbC+4L0Wq\n6bGvqhknMQzbA7Sqr2KYs/F4yXViIXnSEIeQLFlPTeiNId9ADlBpgc1X2B8/EjEy\nGqE6h5/rcQ/8d6lHV0UPCcsqN5AWaH1lznAHwhkaYBbCG7h4sI8GqfUwjYkCkqdf\nTQna9diYKHJdnp/zn8QGyR/rvsF+j8y1/P1tfdHSx2wsel5k4FHdVTOiJ4+YGkaI\nBTa8xpW5uybMB0l75o3S07ChpoL8FgtD4YwpLBkQMQKBgQD32nSUokRQWGfYYWCC\nGa3IC5ZWcmWZW/R+My8xobh8C2NRHqeZZg1Bv9Q1Fmd7p3+rCBtgUR8W0CV2nfZL\nen3UL0YlbN4iyUjuxOKJRw1glq1kt8+7wtPGh9I3JUbnq6KKqJrE+8lnQrS/KEZ6\ncaVwkgGVUvpd/glnFkrp/fjR0QKBgQDbfQoxd5Yc+RzdhL84wSHVz8+plhC1EXIS\n/pvRHzY1Kmix+zS5ubkgLosBaofB8/EGWapSM6UL1yjO3oaGblP9NmIOe7BOGho0\nZfUI9i0yYoAXJxLNfNUruXX1w8spcQQyRRqi8ASdGwffWIfiChpGomJYQDAc9AMX\nrdkv3MovzwKBgQChcOn+5rMYon0BtGvoUlGfu+xw4pLLEdpvWWekLHK+WayXaiBB\nCvgXm5vd+HnvUWsXPHCYjD5z3aCJYtrKzz6mtyQ5vG/0uKeI3zWvtVhBUeQfdpsY\n8g5/gniq8tz8ig+Vwb0OEfNeD1UsLk+58cyRRolBeosaLh5xx1OElqk8AQKBgQC4\nkHOy1xF2uY+pQogdrGHMTlwcCaFw8QOQr2LNPcayfD/fchKLHn5qbljbTv5rfLqv\nkVSknOLrivi4w+wxPLMJmOJptV6yvkZMy3N6HrAwzx1Q2r1358HFa8WibQr4hR13\nPB7C5ruqdGFxURuqWr5vqPqzpP4QSqwTDFA2bB3khwKBgGORfl17Ab+nUCPt6qQ6\n5sKnHc9GMaXdalCDUQBhraZKA7dQS7R/k2YCpFNruFXGsadajxofoyI5b6OlJJnJ\nQLHzYEhnOzxRCVUmvY8XL1yuyMyHFeEcAlzacle7kdgOcTVq9yan4pIVTEDqpcNJ\noZtw+ww5FkJiPr3GlJAD9REI\n-----END PRIVATE KEY-----\n",
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
