import 'dart:math';

import 'package:bookies/category.dart';
import 'package:bookies/home1.dart';
import 'package:bookies/login.dart';
import 'package:bookies/profile.dart';
import 'package:bookies/search.dart';
import 'package:bookies/signup.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modal/category.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int currentIndex = 0;

  int _currentIn = 0;

  // add category image and name
  List<Widget> widgetList = [Home1(),MyCategory(),MySearch(),MyLogin()];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          toolbarHeight: 0,
          title: Text('APP BAR'),
        ),
        body:
         widgetList[_currentIn],
    bottomNavigationBar: Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(40)),
    child: BottomNavigationBar(
    elevation: 10,
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.blue,
    selectedItemColor: Colors.amber,
    currentIndex: _currentIn,
    onTap: (index){
    setState(() {
    _currentIn = index;
    });
    },
    type: BottomNavigationBarType.fixed,
    items: [
    BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
    backgroundColor: Colors.blue,
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.category),
    label: 'Category',
    backgroundColor: Colors.blue,

    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: 'Search',
    backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
    backgroundColor: Colors.blue,
    ),
    ]
    ,
    )
    ,
    )
    ,
    );
  }
}
