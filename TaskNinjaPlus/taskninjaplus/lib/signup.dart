import 'package:flutter/material.dart';
import 'authservice.dart';
import 'login.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String username;
  String email;
  User({required this.username, required this.email});

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
      };
}

Future<void> addUser(User user) async {
  const apiUrl =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/users/new";
  final headers = {'Content-Type': 'application/json'};
  final jsonBody = jsonEncode(user.toJson());

  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);

  if (response.statusCode == 201) {
    print('user added successfully');
  } else {
    //error adding user
  }
  createShurikenList(user.email);
}

Future<void> addNewUser(String username, String email) async {
  const apiUrl =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/users/new";
  final headers = {'Content-Type': 'application/json'};
  var data = {"username": username, "email": email};
  final jsonBody = jsonEncode(data);
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: jsonBody);

  if (response.statusCode == 201) {
    print('user added successfully');
  } else {
    //error adding user
  }
  createShurikenList(email);
}

Future<int> getUserID(String email) async {
  const apiUrl =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/getuserid?email=";
  var apiURL = apiUrl + email;
  final response = await http.get(Uri.parse(apiURL));
  final responsebody = response.body.substring(1, response.body.length - 1);
  Map<String, dynamic> responseMap = jsonDecode(responsebody);
  int userID = responseMap['userid'];
  print(userID.toString());
  return userID;
}

Future<void> createShurikenList(String email) async {
  const apiUrl =
      "https://us-central1-taskninjaplus.cloudfunctions.net/taskninjafunction/createshurikenlist";
  final headers = {'Content-Type': 'application/json'};
  final userID = await getUserID(email);
  print(userID.toString());
  final response = await http.post(Uri.parse(apiUrl),
      headers: headers, body: json.encode({'userID': userID.toString()}));
  if (response.statusCode == 200) {
    print('SHURIKENL;KAJSDF;KLA list made successfully');
    print(response.body);
  } else {
    print('something went wrong');
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpPage> {
  String _userEmail = '';
  String _userPass = '';
  String _userName = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 90,
              centerTitle: true,
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 50,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
              ),
              title: const Text(
                'TaskNinjaPlus',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40, // increase the font size of the text
                ),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 165, 165, 165),
            body: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: (MediaQuery.of(context).size.height * 0.75),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 221, 221),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Sign Up",
                          style: TextStyle(
                            fontSize: 60,
                            color: Color.fromARGB(200, 13, 15, 41),
                          )),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _userName = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Username",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _userEmail = value;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: "Email Address",
                              suffixIcon: Icon(Icons.email)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _userPass = value;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: "Password",
                              suffixIcon: Icon(Icons.password)),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 0, 79, 143),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                        ),
                        onPressed: () {
                          FirebaseAuthServices.signUpWithEmailAndPassword(
                              _userEmail, _userPass, context);
                          User newUser =
                              User(email: _userEmail, username: _userName);
                          addUser(newUser);
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(198, 0, 0, 0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 49, 49, 49)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15)),
                        ),
                        child: const Text('Log In',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(197, 255, 255, 255),
                            )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //Comment out this part of the code in the NON-TEST File!
                      // BottomAppBar(
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 16.0, vertical: 8.0),
                      //     child: Text('You entered: $_userEmail and $_userPass'),
                      //   ),
                      // ),
                    ],
                  )),
            )));
  }
}
