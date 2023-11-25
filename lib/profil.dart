import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Import package path_provider
import 'package:sneaker_apps/edit_profile.dart';
import 'package:sneaker_apps/helper/dbhelper.dart';
import 'package:sneaker_apps/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_apps/models/UserModel.dart';
import 'package:sqflite/sqflite.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences logindata;
  late String username = "";
  List<Users> userList = [];
  bool _isLoading = true;

  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    initial();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
    getUsers();
  }

  Future<List<Users>> getUsers() async {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Users>> userListFuture = dbHelper.getUsers(username);
      userListFuture.then((_userList) {
        if (mounted) {
          setState(() {
            userList = _userList;
          });
        }
      });
    });
    return userList;
  }

  final double coverHeight = 280;
  final double profileHeight = 144;

  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      Directory? appDocDir = await getExternalStorageDirectory();
      String appDocPath = appDocDir!.path;

      String destinationPath =
          '$appDocPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await imageTemp.copy(destinationPath);

      editFoto(destinationPath, username);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      Directory? appDocDir = await getExternalStorageDirectory();
      String appDocPath = appDocDir!.path;

      String destinationPath =
          '$appDocPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await imageTemp.copy(destinationPath);

      editFoto(destinationPath, username);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditProfile();
              }));
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                buildTop(),
                buildContent(),
                Container(
                  width: double.infinity,
                  child: FutureBuilder<List<Users>>(
                    future: getUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Full Name",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    snapshot.data![0].fullName ?? "Unknown",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Text("No data");
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: FutureBuilder<List<Users>>(
                    future: getUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone Number",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    userList[0].phone ?? "Unknown",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Text("No data");
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: FutureBuilder<List<Users>>(
                    future: getUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Password",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    userList[0].userPassword ?? "Unknown",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Text("No data");
                      }
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logindata.setBool('login', true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        },
        backgroundColor: Colors.red,
        tooltip: 'Logout',
        child: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 1.3;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 125,
          margin: EdgeInsets.only(bottom: bottom),
          color: Colors.black87,
        ),
        Positioned(
          top: top,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 30),
                ),
              ],
            ),
            height: 400,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        Positioned(
          top: top - 120,
          child: imageProfile(),
        ),
      ],
    );
  }

  Widget buildContent() => Column(
        children: [
          Text(
            "Hello, " + username,
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
        ],
      );

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: profileHeight / 2,
            backgroundImage: image != null
                ? FileImage(image!) as ImageProvider<Object>
                : (userList.isNotEmpty &&
                        userList[0].gambar != null &&
                        userList[0].gambar!.isNotEmpty)
                    ? FileImage(File(userList[0].gambar!))
                        as ImageProvider<Object>
                    : const AssetImage('assets/image/user_profile.png')
                        as ImageProvider<Object>,
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  pickImageC();
                  Navigator.pop(context);
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () {
                  pickImage();
                  Navigator.pop(context);
                },
                label: const Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  editFoto(String gambar, String username) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute('UPDATE akun SET gambar=? WHERE userName=?', [gambar, username]);
    await batch.commit();
  }
}
