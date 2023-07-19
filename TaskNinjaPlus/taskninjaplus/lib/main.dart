import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'signup.dart';
import 'shuriken.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FirebaseOptions options = const FirebaseOptions(
    apiKey: "AIzaSyCTz06aptkxVRkgO-z4eAV77Cj70Ff8kts",
    authDomain: "taskninjaplus.firebaseapp.com",
    projectId: "taskninjaplus",
    storageBucket: "taskninjaplus.appspot.com",
    messagingSenderId: "695133719561",
    appId: "1:695133719561:web:89588e4c0659a18454bcd8",
    measurementId: "G-QT936Z491N");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AuthPage());
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '6Scheduler Authentication',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List data = [];
  var user;

  Future<String> getData() async {
    var response = await http.get(
      Uri.parse("http://localhost:3000/users"),
    );
    setState(() {
      data = json.decode(response.body) as List<dynamic>;
      user = data[0];
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Image.asset(
                'assets/image/TaskNinjaLogo.png', // replace with your image path
                fit: BoxFit.contain,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors
                .transparent, // set the background color of Scaffold to transparent
            body: Center(
              child: SizedBox(
                width: 600,
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to:',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 219, 219, 219)),
                    ),
                    const Text("TaskNinjaPlus",
                        style: TextStyle(
                          fontSize: 60,
                          color: Color.fromARGB(255, 219, 219, 219),
                        )),
                    const SizedBox(
                      height: 50,
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
                            const Color.fromARGB(255, 0, 79, 143)),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text("Log In",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(199, 0, 0, 0),
                          )),
                    ),
                    const SizedBox(
                      height: 25,
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
                          const Color.fromARGB(255, 141, 141, 141),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(199, 0, 0, 0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
