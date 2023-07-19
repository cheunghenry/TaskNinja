//import 'dart:ffi';
// Name: Josuel Corporan Vargas
// Date: 05/01/2023
// Important Variables: buttonList[] (Holds infos for the all the lists full of Buttons created)
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:namer_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Task class made for each shuriken.
class Task {
  // Padding var that will contain an elevated button
  late Padding moreButton;
  // Padding var that will contain an elevated button
  late Padding deleteButton;
  // TextEditingController var that will be used to store
  late TextEditingController desc = TextEditingController();
  // TextEditingCOntroller var that will be used to store task assignees
  late TextEditingController assignees = TextEditingController();
  // Var used to declare index where task is located
  late int taskIndex = 0;
  // TextEditingController var used as a texteditingcontroller/
  late TextEditingController taskTitle = TextEditingController();
  // Text name used for task
  late Text name;
  // Text name used for bar name.
  late Text barName;
}

// Shuriken class
class Shuriken {
  // Shuriken name
  late String sName;
  // Padding var that will contain button
  late Padding launch;
  // List of tasks shuriken will contain
  late var taskList = [];
  // Index number.
  late int i = 0;
}

//Create Shuriken object to keep track on Shuriken Number.
Shuriken indexShuriken = Shuriken();
//int index = 0;
int taskIndex = 0;
// Current shuriken object
late Shuriken currentObject;
// Current task object
Task currentTask = Task();
// List of shurikens.
var shurikenList = [];

Future<int> getUID() async {
  final email = FirebaseAuth.instance.currentUser!.email;
  const apiUrl =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/getuserid?email=";
  var apiURL = apiUrl + email!;
  final response = await http.get(Uri.parse(apiURL));
  final responsebody = response.body.substring(1, response.body.length - 1);
  Map<String, dynamic> responseMap = jsonDecode(responsebody);
  int userID = responseMap['userid'];
  return userID;
}

Future<List> getShurikens() async {
  const apiUrl =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/getshurikens?userID=";
  final userID = await getUID();
  var apiURL = apiUrl + userID.toString();
  final response = await http.get(Uri.parse(apiURL));
  var titles = response.body;
  final List<dynamic> listtitles = jsonDecode(titles);
  List<String> titleStrings = [];

  for (var title in listtitles) {
    titleStrings.add(title["title"]);
  }
  print(titleStrings);
  return titleStrings;
}

Future<void> createShuriken(String title) async {
  const apiUrl =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/newshuriken";
  const apiUrl2 =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/createtasklist";
  final headers = {'Content-Type': 'application/json'};
  final userid = await getUID();
  final shurikenID = title + userid.toString();
  var data = {'userID': userid, 'shurikenName': title};
  var data2 = {'shurikenID': shurikenID};
  final jsonBody = jsonEncode(data);
  final jsonBody2 = jsonEncode(data2);
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);
  final response2 =
      await http.post(Uri.parse(apiUrl2), headers: headers, body: jsonBody2);
  if (response.statusCode == 201) {
    print('new shuriken added successfully');
  } else {
    print('something went wrong');
  }
  if (response2.statusCode == 200) {
    print('Task List made successfully');
  } else {
    print('something went wrong with task list');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  MyHomePageState createState() => MyHomePageState();
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  SecondPageState createState() => SecondPageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future<List> getTitles() async {
    return await getShurikens();
  }

  int totalShurikens = 1;
  void makePadding(List<String> names) {
    for (int i = 0; i < names.length; i++) {
      const spart = 'Shuriken ';
      final name = spart + totalShurikens.toString();
      Shuriken newShuriken = Shuriken();
      newShuriken.sName = name;
      newShuriken.launch = Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentObject = newShuriken;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondPage()));
                });
              },
              child: const Text('Launch')));
      shurikenList.add(Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppBar(
              title: Text(newShuriken.sName),
              backgroundColor: Colors.grey,
              actions: <Widget>[newShuriken.launch])));
      totalShurikens += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> shurikenNames;
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder<List>(
        future: getTitles(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            shurikenNames = snapshot.data!.cast<String>();
            //totalShurikens = shurikenNames.length;
            makePadding(shurikenNames);
            return MaterialApp(
                home: Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                toolbarHeight: 90,
                leading: IconButton(
                  // Icon will be used to return to the previous page.
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 50,
                  ),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginPage())); // Go to the previous page
                    });
                  },
                ),
                centerTitle: true,
                title: const Text(
                  'Your Shurikens',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),

              // We use the single child scroll view to allow for the user to scroll.
              body: SingleChildScrollView(
                // Column is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
                  // Column is also a layout widget. It takes a list of children and
                  // arranges them vertically. By default, it sizes itself to fit its
                  // children horizontally, and tries to be as tall as its parent.
                  //
                  // Invoke "debug painting" (press "p" in the console, choose the
                  // "Toggle Debug Paint" action from the Flutter Inspector in Android
                  // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                  // to see the wireframe for each widget.
                  //
                  // Column has various properties to control how it sizes itself and
                  // how it positions its children. Here we use mainAxisAlignment to
                  // center the children vertically; the main axis here is the vertical
                  // axis because Columns are vertical (the cross axis would be
                  // horizontal).
                  children: <Widget>[
                    // For the shurikenList, if it is not empty, we show the elements it has.
                    for (int i = 0; i < shurikenNames.length; i++)
                      if (shurikenList.isNotEmpty) shurikenList.elementAt(i),
                    // We use this app bar which contains a button that creates a new shuriken.
                    AppBar(
                      toolbarHeight: 90,
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      centerTitle: true,
                      title: ElevatedButton(
                        // NEW elevated button
                        onPressed: () {
                          setState(() async {
                            // If the button is pressed, we create a new shuriken.
                            Shuriken newShuriken = Shuriken(); // New shuriken.
                            newShuriken.sName =
                                'Shuriken ${shurikenNames.length + 1}';
                            print(newShuriken.sName);
                            await createShuriken(newShuriken.sName)
                                .then((result) {
                              setState(() {});
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: const Text(
                          'Create Shuriken',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        leading: IconButton(
          // Icon us to the home page.
          icon: const Icon(
            Icons.arrow_back,
            size: 50,
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage())); // Go to the home page
            });
          },
        ),
        centerTitle: true,
        title: Text(
          currentObject.sName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // For the list of tasks in the current shuriken object, if it is not empty,
            // we deicde to show the objects.
            for (int i = 0; i < currentObject.taskList.length; i++)
              if (currentObject.taskList.isNotEmpty)
                currentObject.taskList.elementAt(i),
            // App bar with elevated button/
            AppBar(
                toolbarHeight: 90,
                centerTitle: true,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                title: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // If button is pressed, we create a new task
                        Task shurikenTask = Task();
                        // Name of the task
                        shurikenTask.name = Text(
                          "Task ${(currentObject.taskList.length - shurikenTask.taskIndex) + 1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        );
                        // Increase task index
                        shurikenTask.taskIndex++;
                        // Padding with a button that will open up a pop-up dialog, showing us the title, description, and assignees of a task
                        shurikenTask.moreButton = Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  final text1 = TextEditingController();
                                  // If pressed a show a dialog
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Details"),
                                          content: Column(
                                            children: <Widget>[
                                              const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Text(
                                                    "Title",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(shurikenTask
                                                    .taskTitle.text),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  "Description",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                    shurikenTask.desc.text),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  "Assignees",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(shurikenTask
                                                    .assignees.text),
                                              )
                                            ],
                                          ),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Edit Details"),
                                                          content: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      shurikenTask
                                                                          .taskTitle,
                                                                  obscureText:
                                                                      false,
                                                                  decoration: const InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          "Title"),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      shurikenTask
                                                                          .desc,
                                                                  maxLines: 10,
                                                                  obscureText:
                                                                      false,
                                                                  decoration: const InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          "Description"),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      shurikenTask
                                                                          .assignees,
                                                                  obscureText:
                                                                      false,
                                                                  decoration: const InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      labelText:
                                                                          "Assignees"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          actions: <Widget>[
                                                            MaterialButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  0,
                                                                  0,
                                                                  175),
                                                              child: const Text(
                                                                  "Finish"),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                });
                                              },
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 230),
                                              child: const Text("Edit"),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              color: const Color.fromARGB(
                                                  255, 200, 0, 0),
                                              child: const Text("OK"),
                                            )
                                          ],
                                        );
                                      });
                                });
                              },
                              child: const Text("Details")),
                        );

                        shurikenTask.deleteButton = Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentObject.taskList.removeAt(
                                      currentObject.taskList.length -
                                          shurikenTask.taskIndex);
                                });
                              },
                              child: const Text("Delete")),
                        );
                        taskIndex++;
                        currentObject.taskList.add(Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppBar(
                            title: Column(
                              children: <Widget>[
                                shurikenTask.name,
                              ],
                            ),
                            backgroundColor: Colors.grey,
                            toolbarHeight: 90,
                            actions: <Widget>[
                              Column(
                                children: [
                                  shurikenTask.moreButton,
                                  shurikenTask.deleteButton,
                                ],
                              )
                            ],
                          ),
                        ));
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text(
                      "Create Task",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )))
          ],
        ),
      ),
    ));
  }
}
