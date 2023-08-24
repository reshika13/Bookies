import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
     body: Center(

       child: Text('Home Page'),
     ),
       drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset('assets/images/b.jpg',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text('abc@mail.com',style: TextStyle(
                    color: Colors.white,
                  ),),
                ],
              ),
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: (){

              },
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: (){
              },
            ),
            ListTile(
              title: const Text('My Cart'),
              onTap: (){

              }

            ),
            ListTile(
              title: Text('About Us'),
              onTap: (){

              },
            ),
            ListTile(
              title: Text('Contact US'),
              onTap: (){

              },
            )
          ],
        ),
    ),
    );


  }
}
