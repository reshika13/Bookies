import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker picker = ImagePicker();
  String imgPath = '';
  File? selectedImageFile;
  final dbRef = FirebaseDatabase.instance.ref('Users');
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My profile'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blueAccent,
        ),
      ),
      body: StreamBuilder(
        stream: dbRef.child(auth.currentUser!.uid.toString()).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return Text('no record');
          } else {
            //print(snapshot.data!.snapshot.value);
            Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as dynamic;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      openImagechooserDialog();
                      print('Image clicked');
                    },
                    child: ClipOval(
                        child: Image.network(
                      data['image'] == null
                          ? 'https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg'
                          : data['image'],
                      fit: BoxFit.fill,
                      height: 100,
                      width: 100,
                    )),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.amber,
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text('Name'),
                    textColor: Colors.white,
                    subtitle: Text(data['name'].toString()),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.amber.shade700,
                    leading: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    title: Text('Email'),
                    subtitle: Text(
                        data['email'].toString()), //yo server bata fetch hunxa
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.amber,
                    leading: Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    title: Text('Address'),
                    subtitle: Text(data['address'].toString()),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.amber.shade700,
                    leading: Icon(
                      Icons.key,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    title: Text('Password'),
                    subtitle: Text(data['password']
                        .toString()), //yo server bata fetch hunxa
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void openImagePicker() async {
    ImagePicker picker = ImagePicker();
    XFile? imgFile = await picker.pickImage(source: ImageSource.camera);
    if (imgFile != null) {
      sendImageToFirebase(imgFile);
    } else {
      imgPath = 'No image has been selected';
    }
  }

  void pickFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? imgFile = await picker.pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      sendImageToFirebase(imgFile);
    } else {
      imgPath = 'No image has been selected';
    }
  }

  void sendImageToFirebase(XFile imgFile) async {
    final stref = await FirebaseStorage.instance.ref('Users');
    var fileName = DateTime.now().microsecondsSinceEpoch.toString();

    //store image choose from gallary to firebase storage
    await stref.child('image/$fileName').putFile(File(imgFile.path));

    //get download url of upload image
    var imgUrl = await stref.child('image/$fileName').getDownloadURL();

    final mAuth = FirebaseAuth.instance;
    final dbRef = FirebaseDatabase.instance.ref('Users');
    var respo = await dbRef
        .child(mAuth.currentUser!.uid.toString())
        .update({'image': imgUrl}).whenComplete(() => {
              showMySnackBar(
                'Profile picture updated',
                Colors.green,
                4,
              )
            });
  }

  void showMySnackBar(String msg, Color color, int time) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: time),
      backgroundColor: color,
      content: Text(msg),
    ));
  }

  void openImagechooserDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 100,
              child: Column(
                children: [
                  TextButton(
                      onPressed: () {
                        pickFromGallery();
                        Navigator.pop(context);
                      },
                      child: Text('Choose from Gallery')),
                  TextButton(
                      onPressed: () {
                        openImagePicker();
                        Navigator.pop(context);

                      },
                      child: Text('Choose from Camera')),
                ],
              ),
            ),
          );
        });
  }
}
