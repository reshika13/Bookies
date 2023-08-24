import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProDetails extends StatefulWidget {
  const ProDetails({Key? key}) : super(key: key);

  @override
  State<ProDetails> createState() => _ProDetailsState();
}

class _ProDetailsState extends State<ProDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.network(
                "https://bookshopapocalypse.com/cdn/shop/products/harrypottergobletoffireUK-1sq_1024x1024@2x.jpg?v=1639264140"),
          ),
          buttonArrow(context),
          scroll(),
        ],
      ),
    ));
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        )
                      ],
                    ),
                  ),
                  Text(
                    "Harry Potter & the Goblet of Fire",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,

                    ),
                  ),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Ya book ko barema bla bla bla k k lekhne... jlkjak hjkjks hk h  ehsk',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Author",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),

                  const SizedBox(height: 10,),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) => ingredients(context),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),

                  Text(
                    "Publisher",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10,),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) => steps(context,index),
                  ),


                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10,),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) => ingredients(context),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

      ingredients(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [

      const SizedBox(width: 10,),
      Text("JKdfcjyhgdcjygh ",style: Theme.of(context).textTheme.bodyLarge,

      ),
    ],),
    );
  }



  steps(BuildContext context, int index) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(children: [
    Column(children: [
      Text("Scholastic Press",
      maxLines: 3,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],)
    ],),

    );
  }
}




