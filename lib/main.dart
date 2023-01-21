// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Added to Git

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:my_app/user_sheets_api.dart';
import 'package:my_app/employee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSheetsApi.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyNamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyClockPage extends StatefulWidget {
  const MyClockPage({super.key});

  @override
  State<MyClockPage> createState() => _MyClockPageState();
}

class _MyClockPageState extends State<MyClockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecordDateTime'),
        backgroundColor: const Color.fromARGB(255, 140, 203, 255),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 30,
              width: 1,
            ),

            const SizedBox(
              height: 1,
              width: 20,
            ),

            Text(
              "Hi, ${UserSheetsApi.employees[UserSheetsApi.getCurrentIndex()].name}!",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 1,
              width: 100,
            ),

            const SizedBox(
              height: 20,
              width: 1,
            ),
            Text(
              UserSheetsApi.dateDisplay(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
              width: 1,
            ),

            //CLOCK IN BUTTON
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100.0, vertical: 50.0),
                  backgroundColor: const Color.fromARGB(255, 140, 203, 255),
                  shape: const StadiumBorder(),
                ),
                onPressed: !UserSheetsApi
                        .employees[UserSheetsApi.getCurrentIndex()].isClockedIn
                    ? () {
                        debugPrint("dialog opened - clock in");
                        debugPrint(
                            "object details: ${UserSheetsApi.employees[UserSheetsApi.getCurrentIndex()].toString()}");
                        debugPrint(
                            "is clocked in? ${UserSheetsApi.employees[UserSheetsApi.getCurrentIndex()].isClockedIn}");
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                      "Are you sure you want to check in?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            UserSheetsApi.insertClockIn();
                                          });
                                          debugPrint("clock in confirmed");

                                          Navigator.pop(context);
                                        },
                                        child: const Text("Yes")),
                                    TextButton(
                                      onPressed: () {
                                        debugPrint("clock in denied");
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"),
                                    )
                                  ],
                                ));
                      }
                    : null,
                child: const Text('clock in')),
            const SizedBox(
              height: 20,
              width: 1,
            ),

            Text(
                "STATUS: CLOCKED IN AT ${UserSheetsApi.employees[UserSheetsApi.getCurrentIndex()].checkInTime}"),

            const SizedBox(
              height: 20,
              width: 1,
            ),
            //CLOCK OUT BUTTON
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100.0, vertical: 50.0),
                  backgroundColor: const Color.fromARGB(255, 140, 203, 255),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  debugPrint("dialog opened - clock out");

                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: const Text(
                                  "Are you sure you want to check out?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    debugPrint("clock out confirmed");
                                    setState(() {
                                      UserSheetsApi.insertClockOut();
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    debugPrint("clock out denied");
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"),
                                )
                              ]));
                },
                child: const Text('clock out')),
            const SizedBox(
              height: 20,
              width: 1,
            ),
            Text(
                "STATUS: CLOCKED OUT AT ${UserSheetsApi.employees[UserSheetsApi.getCurrentIndex()].checkOutTime}"),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}

class MyNamePage extends StatefulWidget {
  const MyNamePage({super.key});

  @override
  State<MyNamePage> createState() => _MyNamePageState();
}

class _MyNamePageState extends State<MyNamePage> {
  final List<String> names = ['test'];

  var currentName = "";

  _MyNamePageState() {
    UserSheetsApi.loadNames(this);
    UserSheetsApi.loadDates(this);
    //UserSheetsApi.fillTopRow(this);
  }

  @override
  Widget build(BuildContext context) {
    const title = "Sunnyvale Kumon Center";
    debugPrint("names:$names");
    debugPrint(UserSheetsApi.names[0]);
    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
            backgroundColor: const Color.fromARGB(255, 140, 203, 255),
          ),
          body: Center(
              child: ListView.builder(
            itemCount: UserSheetsApi.names.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.circle),
                title: Text(
                  UserSheetsApi.names.isNotEmpty
                      ? UserSheetsApi.names[index]
                      : "test",
                  textAlign: TextAlign.left, //this is default
                  style: const TextStyle(fontSize: 17),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 30.0, //margins from side of phone
                  vertical: 12.0, //between list items
                ),
                onTap: () {
                  debugPrint("name tapped");
                  currentName = UserSheetsApi.names[index];
                  UserSheetsApi.passCurrentIndex(index);
                  debugPrint(
                      "current index - accessed through class variable: ${UserSheetsApi.currentIndex}");
                  debugPrint(currentName);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyClockPage()),
                  );
                },
              );
            },
          ))),
    );
  }
}
