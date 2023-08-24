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
  final List<Map<String, dynamic>> gridMap = [
    {
      "title": "Harry Potter and the Goblet of Fire",
      "price": "\$150",
      "images":
      "https://bookshopapocalypse.com/cdn/shop/products/harrypottergobletoffireUK-1sq_1024x1024@2x.jpg?v=1639264140",
    },
    {
      "title": "Karnali Blues",
      "price": "\$100",
      "images":
      "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1298524190i/10579909.jpg",
    },
    {
      "title": "Shirish ko phool",
      "price": "\$250",
      "images":
      "https://upload.wikimedia.org/wikipedia/commons/e/e1/Shirish_ko_Phool.jpg",
    },
    {
      "title": "The Alchemist",
      "price": "\$200",
      "images":
      "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1654371463i/18144590.jpg",
    },
    {
      "title": "The Seven Husband of Evelyn Hugo",
      "price": "\$250",
      "images": "https://media.thuprai.com/front_covers/11hus.jpg",
    },
    {
      "title": "The Secret",
      "price": "\$150",
      "images":
      "https://m.media-amazon.com/images/I/61xj06cGiML._AC_UF1000,1000_QL80_.jpg",
    },
  ];

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
              List<dynamic> catList = snapshot.data!.snapshot.value.toList();
              catList.removeAt(0);
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
                          itemCount: catList.length,
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
                                            cat: catList[index])));
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
                                        "${catList[index]['image']}",
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
                                            "${catList[index]['name']}",
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
