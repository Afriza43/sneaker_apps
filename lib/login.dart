import 'package:sneaker_apps/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:sneaker_apps/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
  }

  void checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = logindata.getBool('login') ?? true;
    print(newuser);
    if (!newuser) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const BottomNavigation();
      }));
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 62),
              Lottie.asset(
                "./assets/lottie/sneaker_log.json",
                width: 300,
                height: 250,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to ",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Snea",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "Ky",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.orangeAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    // You can customize other properties based on your preference
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.orangeAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    // You can customize other properties based on your preference
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () async {
                  String username = _username.text;
                  String password = _password.text;

                  if (password == "123") {
                    String hashedPassword = await hashPassword(password);

                    if (username == "user" &&
                        verifyPassword(password, hashedPassword)) {
                      print("Hashed Password: $hashedPassword");

                      logindata.setBool("login", false);
                      logindata.setString("username", username);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const BottomNavigation();
                      }));
                    }
                  } else {
                    // Show red snackbar with "Password Salah" message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Password Salah",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                },
                child: Text(
                  "Login",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the registration page
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const RegisterPage();
                  }));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have no account? ",
                      style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ),
                    Text(
                      "Register here",
                      style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(color: Colors.indigo, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to hash the password
  Future<String> hashPassword(String password) async {
    const rounds = 12; // You can adjust the number of rounds as needed
    return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: rounds));
  }

  // Function to verify the password
  bool verifyPassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }
}
