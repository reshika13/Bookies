import 'package:flutter/material.dart';

class Novel extends StatefulWidget {
  const Novel({Key? key}) : super(key: key);

  @override
  State<Novel> createState() => _NovelState();
}

class _NovelState extends State<Novel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              width: 100,
              height: 100,
              child: Image.asset('assets/images/karnali.jpg'),
            ),

          ],
        ),
      ),
    );
  }
}
