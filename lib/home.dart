// ignore_for_file: unused_local_variable

import 'package:intl/intl.dart';
import 'package:sneaker_apps/detail_produk.dart';
import 'package:sneaker_apps/models/SneakerModel.dart';
import 'package:sneaker_apps/service/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";

  final TextEditingController _searchController = TextEditingController();
  List<Sneaker>? sneakers;
  List<Sneaker>? filteredSneakers;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
    initial();
  }

  getData() async {
    sneakers = await RemoteService().getSneakers();
    if (sneakers != null) {
      setState(() {
        isLoaded = true;
        filteredSneakers = sneakers;
      });
    }
  }

  void initial() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? "";
    });
  }

  void onSearchTextChanged(String query) {
    setState(() {
      filteredSneakers = sneakers
          ?.where((sneaker) =>
              sneaker.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Sneaker>? displaySneakers =
        _searchController.text.isNotEmpty ? filteredSneakers : sneakers;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 10,
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Discover the Latest Sneakers',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start),
                      SizedBox(height: 30),
                      TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.black),
                        onChanged: onSearchTextChanged,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 17),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_searchController.text.isEmpty)
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final Sneaker sneaker = sneakers![index];
                    if (sneakers != null &&
                        sneakers!.isNotEmpty &&
                        index < sneakers!.length) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailSneakers(sepatu: sneaker);
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.white70,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.white70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                      bottom: Radius.circular(8),
                                    ),
                                    child: Image.network(
                                      filteredSneakers![index].gambar,
                                      width: 170,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        filteredSneakers![index].nama,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black87,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                      'Rp ' +
                                          NumberFormat.currency(
                                                  locale: 'ID',
                                                  symbol: "",
                                                  decimalDigits: 0)
                                              .format(int.parse(
                                                  filteredSneakers![index]
                                                      .harga))
                                              .toString(),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black54,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 12)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  childCount: sneakers != null ? sneakers!.length : 0,
                ),
              ),
            if (_searchController.text.isNotEmpty)
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final Sneaker pc = filteredSneakers![index];
                    if (filteredSneakers != null &&
                        filteredSneakers!.isNotEmpty &&
                        index < filteredSneakers!.length) {
                      final Sneaker sneaker = filteredSneakers![index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailSneakers(sepatu: sneaker);
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.white70,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.white70,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                      bottom: Radius.circular(8),
                                    ),
                                    child: Image.network(
                                      filteredSneakers![index].gambar,
                                      width: 170,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        filteredSneakers![index].nama,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black87,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Rp ' +
                                        NumberFormat.currency(
                                                locale: 'ID',
                                                symbol: "",
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                filteredSneakers![index].harga))
                                            .toString(),
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black54,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  childCount:
                      filteredSneakers != null ? filteredSneakers!.length : 0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileAvatar(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 30, // Adjust the radius as needed
      ),
    );
  }
}
