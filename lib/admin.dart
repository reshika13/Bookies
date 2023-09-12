import 'dart:math';

import 'package:bookies/admin/catscreen.dart';
import 'package:bookies/prodesc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin/proscreen.dart';

class MyAdmin extends StatefulWidget {
  const MyAdmin({Key? key}) : super(key: key);

  @override
  State<MyAdmin> createState() => _MyAdminState();
}

class _MyAdminState extends State<MyAdmin> {
  final dbRef = FirebaseDatabase.instance.ref('Category');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple.shade700,
        appBar: AppBar(
          title: const Text(
            "Admin Panel",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>CatScreen()));
                        },
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.greenAccent.shade700,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            Text(
                              "Categories",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(right: 40),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProScreen()),
                        );
                      },
                      child: Container(
                        // decoration: BoxDecoration(
                        //   color: Colors.blue,
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.37,
                        color: Colors.redAccent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.list,
                              color: Colors.white,
                            ),
                            Text(
                              "Products",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Log out',
                            textAlign: TextAlign.center,
                          ),
                          content: Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                // Close the dialog
                                Navigator.pushNamed(context, 'login');
                              },
                              child: Text('Log out'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform a different action when the "Cancel" button is pressed
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.purple,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  showCatList() {
    return Container(
      height: 110,
      child: StreamBuilder(
        stream: dbRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Text('no data');
          } else {
            List<dynamic> catlist = snapshot.data!.snapshot.value.toList();
            catlist.removeAt(0);
            print(catlist![0]['name']);
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catlist.length,
              itemBuilder: (BuildContext context, int index) {
                Color randomColor =
                    Color(Random().nextInt(0xFFFFFFFF)).withOpacity(1.0);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProScr(cat: catlist[index])));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: randomColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(right: 14),
                    padding: EdgeInsets.only(top: 10),
                    height: 100,
                    width: 100,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            catlist[index]['image']!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          child: Text(
                            catlist[index]['name']!,
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
