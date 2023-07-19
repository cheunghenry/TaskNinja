import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namer_app/shuriken.dart';
import 'authservice.dart';
import 'googleauth.dart';
import 'signup.dart';
import 'main.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '6Scheduler Authentication',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<LoginPage> {
  String _userEmail = '';
  String _userPass = '';

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
                      const Text("Log In",
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
                          FirebaseAuthServices.signInWithEmailAndPassword(
                            _userEmail,
                            _userPass,
                            context,
                          );
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(198, 0, 0, 0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //This is the part for Google Auth.
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () => {GoogleAuth().loginViaGoogle(context)},
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/image/google_logo.png',
                                  height: 30),
                              const SizedBox(width: 10),
                              const Text('Log In via Google',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),

                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     shape: MaterialStateProperty.all<OutlinedBorder>(
                      //       RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //     ),
                      //     backgroundColor: MaterialStateProperty.all<Color>(
                      //       Color.fromARGB(255, 255, 255, 255),
                      //     ),
                      //     padding: MaterialStateProperty.all<EdgeInsets>(
                      //       const EdgeInsets.symmetric(
                      //         horizontal: 30,
                      //         vertical: 15,
                      //       ),
                      //     ),
                      //   ),
                      //   onPressed: () => {GoogleAuth().loginViaGoogle(context)},
                      //   child: const Text(
                      //     "Log In with Google",
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold,
                      //       color: Color.fromARGB(198, 0, 0, 0),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Don't have an account?",
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
                                  horizontal: 30, vertical: 10)),
                        ),
                        child: const Text('Sign Up',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(197, 255, 255, 255),
                            )),
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
