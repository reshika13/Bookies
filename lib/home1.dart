import 'dart:math';

import 'package:bookies/prodesc.dart';
import 'package:bookies/productdetails.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modal/category.dart';

class Home1 extends StatefulWidget {
  const Home1({Key? key}) : super(key: key);

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {

  final dbRef = FirebaseDatabase.instance.ref('Category');
  final dbProd = FirebaseDatabase.instance.ref('Products');

  List imageList = [
    'assets/images/b.jpg',
    'assets/images/hd.jpg',
    'assets/images/nbook.jpg',
    'assets/images/sofabook.jpg'
  ];

  int currentIndex = 0;

  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    var arrColors = [
      Colors.yellow,
      Colors.blue,
      Colors.white,
      Colors.red,
      Colors.lightGreen,
      Colors.pinkAccent,
      Colors.cyanAccent,
    ];

    return Scaffold(
      backgroundColor: Colors.black38,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             buildimageSlider(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Categories',
                style: GoogleFonts.abel(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
buildCategories(),
              SizedBox(
                height: 20,
              ),
            Container(
                child: Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildProducts(),
  ],
          ),
        ),
      ),
    );
  }

  buildimageSlider() {
    return  InkWell(
      onTap: () {
        print(currentIndex);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: CarouselSlider(
          items: imageList
              .map(
                (item) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                item,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          )
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: true,
              aspectRatio: 2,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                // setState(() {
                //   currentIndex = index;
                // });
              }),
        ),
      ),
    );
  }

  buildCategories() {
    return
      Container(
      height: 110,
      child: StreamBuilder(
        stream: dbRef.onValue,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catlist.length,
              itemBuilder: (BuildContext context, int index) {
                Color randomColor =
                Color(Random().nextInt(0xFFFFFFFF))
                    .withOpacity(1.0);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProScr(
                                cat: catlist[index])));                            },
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
                          padding: const EdgeInsets.only(
                              left: 10, right: 8),
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

  buildProducts() {
    return StreamBuilder(
        stream: dbProd.onValue,
        builder: (BuildContext context, AsyncSnapshot<dynamic>snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator(),);
          }
          else if(!snapshot.hasData){
            return Text('no data');
          }
          else{
            List<dynamic>prodList = snapshot.data.snapshot.value.toList();
            prodList.removeAt(0);
            return prodList.isNotEmpty ?
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3.0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prodList.length,
                itemBuilder: (BuildContext context,int index)
                {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>MyDetail(data:prodList[index])));
                    },
                    child:
                    Container(
                      margin: const EdgeInsets.all(10),
                      // padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            child: Image.network(
                              prodList[index]['image'],
                              fit: BoxFit.fill,
                              height: 100,
                              width: double.infinity,

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(  prodList[index]['name'].toString(),

                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,

                                  ),
                                ),
                                SizedBox(height: 2,),
                                Text('Rs ${prodList[index]['price']}',
                                  style: TextStyle(
                                    color: Colors.white,

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ) : Center(child: Text('No Books Found'));
          }
        }

    );
  }
}
