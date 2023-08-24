import 'package:bookies/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _addController = TextEditingController();
  final _roomController = TextEditingController();
  final _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Dahboard'),),
      floatingActionButton: FloatingActionButton(onPressed: (){
      showInputDialog();
      },
      child: Icon(Icons.add),
      ),
      body: Container(

        child: ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
        },
          child: Text('Go to profile'),),

      ),
    );
  }

  void showInputDialog() {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          height: 250,
          child: Column(
            children: [
              TextFormField(
                controller: _addController,
                decoration: InputDecoration(
                  hintText: 'Enter Adress',
                ),

              ),
              TextFormField(
                controller: _roomController,
                decoration: InputDecoration(
                  hintText: 'Enter Room',
                ),

              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: 'Enter price',
                ),

              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  },
                      child: Text('Cancel')),
                  SizedBox(
                    width: 5,

                  ),
                  ElevatedButton(onPressed: (){
                    sendDataToFb();
                  },
                      child: Text('Save')),
                ],
              ),
            ],
          ),
        ),
      );
        });
  }

  void sendDataToFb() {}
}
