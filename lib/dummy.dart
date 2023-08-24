import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';


class Dummy extends StatefulWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}


class _DummyState extends State<Dummy> {
  // List imageList = [
  //   'assets/images/b.jpg',
  //   'assets/images/hd.jpg',
  //   'assets/images/karnali.jpg',
  //   'assets/images/shrish.jpg',
  //   'assets/images/summer.jpg',
  // ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(title: Text('APP BAR'),),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(20.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Something',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Ubuntu',
              ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(padding: const EdgeInsets.only(right: 20),
                    child: Icon(Icons.search,size: 28,color: Colors.white,),
                        ),
                Icon(Icons.settings,size: 28,color: Colors.white),

                ],
              )
            ],
          ),
          SizedBox(height: 50,),
          CarouselSlider(items: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage('assets/images/alchemy.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                image: AssetImage('assets/images/summer.jpg'),
                fit: BoxFit.cover,
              ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage('assets/images/karnali.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),


            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage('assets/images/shrish.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),


          ],
              options: CarouselOptions(
                autoPlay: true,
                height: 400.0,
                autoPlayCurve: Curves.linear,
                enlargeCenterPage: true,
              )
          )
        ],
      ),

    );
  }
}
