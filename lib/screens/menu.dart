import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamfinalproject/model/park.dart';
import 'package:teamfinalproject/repositories/dbhelper.dart';
import 'package:teamfinalproject/screens/home/home.dart';
import 'package:teamfinalproject/screens/map/mapPage.dart';
import 'package:teamfinalproject/services/fetchpark.dart';

class MenuPage extends StatefulWidget {

  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  int _currentIndex = 0;
  final _pages = [
    HomePage(),
    MapPage()
  ];

  Widget build(BuildContext context) {



    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black38,
        selectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(color: Colors.blue),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '장바구니',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
      body:_pages[_currentIndex]
    );
  }
}
