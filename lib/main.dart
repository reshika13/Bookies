
import 'package:bookies/admin.dart';
import 'package:bookies/admin/catscreen.dart';
import 'package:bookies/adventure.dart';
import 'package:bookies/cartpage.dart';
import 'package:bookies/category.dart';
import 'package:bookies/admin/catscreen.dart';

import 'package:bookies/dashboard.dart';
import 'package:bookies/drawer.dart';
import 'package:bookies/dummy.dart';
import 'package:bookies/fantasy.dart';
import 'package:bookies/fiction.dart';
import 'package:bookies/home.dart';
import 'package:bookies/home1.dart';
import 'package:bookies/login.dart';
import 'package:bookies/novel.dart';
import 'package:bookies/prodetails.dart';
import 'package:bookies/productdetails.dart';
import 'package:bookies/profile.dart';
import 'package:bookies/register.dart';
import 'package:bookies/search.dart';
import 'package:bookies/selfhelp.dart';
import 'package:bookies/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'cartprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

      ChangeNotifierProvider(
        create: (context) => CartModel(),
        child: MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'home',
    routes: {
        'drawer': (context) => MyDrawer(),
        'login': (context) => MyLogin(),
        'signup': (context) => MySignup(),
        'home': (context) => MyHomePage(),
        'register': (context) => Register(),
        'novel': (context) => Novel(),
        'fiction': (context) => Fiction(),
        'fantasy': (context) => Fantasy(),
        'selfHelp': (context) => SelfHelp(),
        'dummy': (context) => Dummy(),
        'profile': (context) => Profile(),
        'dashboard': (context) => Dashboard(),
        'home1': (context) => Home1(),
        'category': (context) => MyCategory(),
        'prodetails': (context) => ProDetails(),
        'search': (context) => MySearch(),
        'admin': (context) => MyAdmin(),
        'cartpage': (context) => MyCart(),
        //'productdetails': (context) => MyDetail(),
    },
  ),
      ));
}
