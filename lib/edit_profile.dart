import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_apps/helper/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DBHelper dbHelper = DBHelper();

  final fullName = TextEditingController();
  final phoneNum = TextEditingController();

  late SharedPreferences logindata;
  late String username = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Lottie.asset(
                  "./assets/lottie/edit_profile.json",
                  width: 300,
                  height: 300,
                ),
                TextFormField(
                  controller: fullName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      "Please fill your full name";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: phoneNum,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await editProfile(
                            username, fullName.text, phoneNum.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Profile updated successfully'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Failed to update profile. Error: $e'),
                          ),
                        );
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Update Profile",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  editProfile(String userName, String fullName, String phone) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute('UPDATE akun SET fullName=?, phone=? WHERE userName=?',
        [fullName, phone, userName]);
    await batch.commit();
  }
}
