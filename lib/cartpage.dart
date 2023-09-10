import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<String> productname = ['The Alchemist', 'bbbb', 'ccc', 'ddd', 'eee'];
  List<int> productprice = [10,20,30,40,50];
  List<String> productimage = [
    'https://static.wikia.nocookie.net/qghficsimjkaeibhfztnpjrqiezhzuadzsjxwpnxusefbthfes/images/8/89/Harry_Potter_and_the_Goblet_of_Fire_novel.jpg.webp/revision/latest?cb=20220129182713',
    'https://img.freepik.com/free-photo/book-composition-with-open-book_23-2147690555.jpg',
    'https://images.pexels.com/photos/1643033/pexels-photo-1643033.jpeg?cs=srgb&dl=pexels-natalie-bond-1643033.jpg&fm=jpg',
    'https://images.pexels.com/photos/1643033/pexels-photo-1643033.jpeg?cs=srgb&dl=pexels-natalie-bond-1643033.jpg&fm=jpg',
    'https://images.pexels.com/photos/1643033/pexels-photo-1643033.jpeg?cs=srgb&dl=pexels-natalie-bond-1643033.jpg&fm=jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Cart',
        ),
        centerTitle: true,
        actions: [
         // Center(
         //    child: Badge(
         //       badgeContent: Text('0',style: TextStyle(color: Colors.white),),
         //       animationDuration: Duration(milliseconds: 30),
         //       child: Icon(Icons.shopping_bag_outlined),
         //     ),
         // )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productname.length,
                itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(productimage[index].toString()),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productname[index].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(productprice[index].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Center(
                                      child: Text('Add to cart',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
