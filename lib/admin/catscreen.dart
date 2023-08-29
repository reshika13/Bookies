//import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../prodesc.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({Key? key}) : super(key: key);

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  String userName = '';
  final ImagePicker picker = ImagePicker();
  String imgPath = '';
  File? selectedImageFile;
  final dbRef = FirebaseDatabase.instance.ref('Category');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
      ),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Text('no data');
          } else {
            List<dynamic> catlist = snapshot.data!.snapshot.value.toList();
            catlist.removeAt(0);
            print(catlist![0]['name']);
            return Container(
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: catlist.length,
                itemBuilder: (BuildContext context, int index) {
                  Color randomColor =
                      Color(Random().nextInt(0xFFFFFFFF)).withOpacity(1.0);
                  return Container(
                    decoration: BoxDecoration(
                      color: randomColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(right: 14, left: 14, bottom: 8),
                    padding: EdgeInsets.only(top: 10, left: 10),
                    width: 100,
                    child: Row(
                      children: [
                        Column(
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            catlist[index]['name']!,
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        //SizedBox(width: 150,),
                        Spacer(),
                        InkWell(
                          child: Container(
                              child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        InkWell(
                          onTap: () {
                            // _deleteProduct(prodList[index]['id']);
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the button press here
          openAddDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void openAddDialog() {
    String categoryName = ''; // To store the category name
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Container(
              height: 350, // Increased height to accommodate the TextField
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  selectedImageFile != null
                      ? Image.file(selectedImageFile!,
                          height: 100, width: double.infinity)
                      : const Text('No image selected'),
                  TextButton(
                    onPressed: () async {
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        setState(() {
                          selectedImageFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: Text(
                      'Pick an image',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add some spacing
                  TextFormField(
                    onChanged: (value) {
                      categoryName = value; // Update the category name
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter category name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            print('fffffff');
                            // print('Category Name: $categoryName');
                            // print('Image Path: ${selectedImageFile?.path}');
                            // Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            print('fffffff');
                            // Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _deleteProduct(String productId) async {
    try {
      await dbRef
          .child(productId)
          .remove(); // Remove the product from the database
      // Refresh the UI or perform other necessary actions after deletion
    } catch (error) {
      // Handle error, display a message, etc.
    }
  }
}
