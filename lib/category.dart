//import 'dart:html';
import 'dart:math';

import 'package:bookies/prodesc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modal/category.dart';

class MyCategory extends StatefulWidget {
  const MyCategory({Key? key}) : super(key: key);

  @override
  State<MyCategory> createState() => _MyCategoryState();
}

class _MyCategoryState extends State<MyCategory> {
  final _addController = TextEditingController();
  final _bookController = TextEditingController();
  final _priceController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref('Category');
  final List<Map<String, dynamic>> gridMap = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          title: Text(
            'Categories',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontSize: 28,
              color: Colors.white,
            )),
          ),
          centerTitle: true,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black),
          backgroundColor: Colors.black38,
        ),
        body:
        StreamBuilder(
          stream: dbRef.onValue,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return Text('no data');
            } else {
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
              List<dynamic> catlist = [];
              map.forEach((key, value) {
                catlist.add(value);
              });
              return
                Container(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          padding: EdgeInsets.all(24.0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: catlist.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            mainAxisExtent: 220,
                          ),
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProScr(
                                            cat: catlist[index])));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0)),
                                      child: Image.network(
                                        "${catlist[index]['image']}",
                                        height: 170,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${catlist[index]['name']}",
                                            style: GoogleFonts.lato(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ));
            }
          },
        ));
  }

  void showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            height: 250,
            child: Column(
              children: [
                TextFormField(
                  controller: _addController,
                  decoration: InputDecoration(hintText: 'Enter address'),
                ),
                TextFormField(
                  controller: _bookController,
                  decoration: InputDecoration(hintText: 'Enter n.o of books'),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(hintText: 'Enter rate'),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          sendDataToFirebase();
                        },
                        child: Text('Save')),
                  ],
                )
              ],
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  void sendDataToFirebase() {}
}
