import 'package:flutter/material.dart';

class MyDetail extends StatefulWidget {
  MyDetail({super.key, required this.data});
  Map<dynamic,dynamic>data;


  @override
  State<MyDetail> createState() => _MyDetailState();
}

class _MyDetailState extends State<MyDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      title: Text('PRODUCT DETAILS'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.data['image'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.fill,
            ),
            Text(widget.data['name'].toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.data['price'].toString()),
                Text('qnty add minus')
              ],
            ),
            Text(widget.data['description'].toString()),

          ],
        ),


      ),
    );
  }
}
