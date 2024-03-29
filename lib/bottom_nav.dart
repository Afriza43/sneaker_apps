import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_apps/cart.dart';
import 'package:sneaker_apps/history.dart';
import 'package:sneaker_apps/home.dart';
import 'package:sneaker_apps/profil.dart';
import 'package:sneaker_apps/saran_kesan.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late PageController _pageController;
  int _currentIndex = 0;
  late SharedPreferences logindata;
  late String username = "";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void initial() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? "";
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [
          HomePage(),
          CartPage(),
          HistoryPage(),
          ProfilePage(),
          SaranKesan()
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white70,
        mainAxisAlignment: MainAxisAlignment.center,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentIndex = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.black87 : Colors.grey,
            ),
            activeColor: Colors.transparent,
          ),
          BottomBarItem(
            icon: Icon(
              Icons.shopping_cart_rounded,
              color: _currentIndex == 1 ? Colors.black87 : Colors.grey,
            ),
            activeColor: Colors.transparent,
          ),
          BottomBarItem(
            icon: Icon(
              Icons.history,
              color: _currentIndex == 2 ? Colors.black87 : Colors.grey,
            ),
            activeColor: Colors.transparent,
          ),
          BottomBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3 ? Colors.black87 : Colors.grey,
            ),
            activeColor: Colors.transparent,
          ),
          BottomBarItem(
            icon: Icon(
              Icons.message,
              color: _currentIndex == 4 ? Colors.black87 : Colors.grey,
            ),
            activeColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
