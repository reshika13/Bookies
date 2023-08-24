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
      appBar: AppBar(title: Text('Category List'),),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Text('no data');
          } else {
            List<dynamic> catlist =
            snapshot.data!.snapshot.value.toList();
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
                  Color(Random().nextInt(0xFFFFFFFF))
                      .withOpacity(1.0);
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
                          padding: const EdgeInsets.only(
                              left: 10),
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
                              child: Icon(Icons.edit, color: Colors.white,
                              )),
                        ),
                        SizedBox(width: 6,),
                        InkWell(
                          child: Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Icon(Icons.delete, color: Colors.white,
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
    showDialog(context: context, builder: (BuildContext context) {
      return Dialog(
        child:
        Container(
          height: 250,
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    pickFromGallery();
                    Navigator.pop(context);
                  },
                  child: Text('Choose an image from Gallery')),
            ],
          ),
        ),
      );
    },);
  }

  void pickFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? imgFile = await picker.pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      var image;
      _showImagePreviewDialog(context, File(image.path));

      // sendImageToFirebase(imgFile);
    } else {
      imgPath = 'No image has been selected';
    }
  }

  void sendImageToFirebase(XFile imgFile) async {
    final stref = await FirebaseStorage.instance.ref('Users');
    var fileName = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    //store image choose from gallary to firebase storage
    await stref.child('image/$fileName').putFile(File(imgFile.path));

    //get download url of upload image
    var imgUrl = await stref.child('image/$fileName').getDownloadURL();

    final mAuth = FirebaseAuth.instance;
    final dbRef = FirebaseDatabase.instance.ref('Users');
    var respo = await dbRef
        .child(mAuth.currentUser!.uid.toString())
        .update({'image': imgUrl}).whenComplete(() =>
    {
    });
  }
}

 _showImagePreviewDialog(BuildContext context, File imageFile) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Image Preview'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.file(imageFile),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


