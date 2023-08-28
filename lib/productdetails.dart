import 'package:flutter/material.dart';

class MyDetail extends StatefulWidget {
  MyDetail({super.key, required this.data});
  Map<dynamic,dynamic>data;


  @override
  State<MyDetail> createState() => _MyDetailState();
}

class _MyDetailState extends State<MyDetail> {
  int _quantity = 1;
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
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
            SizedBox(height: 10,),
            Text(widget.data['name'].toString(),
              style: TextStyle(
              fontSize: 30,
                color: Colors.white,

            ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('NRS ${widget.data['price']}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),

                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade700,
                      ),
                      padding: EdgeInsets.all(0.5),
                      margin: EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: _decrementQuantity,
                          icon: Icon(Icons.remove),
                        color: Colors.white,
                      iconSize: 30,
                      ),
                    ),
                    Text(_quantity.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                      shape: BoxShape.circle,
                        color: Colors.purple,
                      ),
                      padding: EdgeInsets.all(0.5),
                      margin: EdgeInsets.only(left: 10),

                      child: IconButton(
                          onPressed: _incrementQuantity,
                          icon: Icon(Icons.add),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    )
                  ],
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: 'Author\n'),
                  TextSpan(
                    text: widget.data['author'],
                    style: TextStyle(
                      fontSize: 20, // Increase the font size for the name
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),

            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: 'Publication\n'),
                  TextSpan(
                    text: widget.data['publisher'],
                    style: TextStyle(
                      fontSize: 20, // Increase the font size for the name
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Text('Details:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Text(widget.data['description'].toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            ),
            Spacer(),
            Center(
              child: Container(
               // color: Colors.purple,
                margin: EdgeInsets.all(10),
                child: ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, 'cartpage');
                },
                  child: Text('Add to cart',
                  style: TextStyle(

                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            )
          ],

        ),


      ),

    );
  }
}


