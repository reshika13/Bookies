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
  final dbRef = FirebaseDatabase.instance.ref('Category');
  bool isClicked = false;
  TextEditingController _catNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Text('no data');
          } else {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
            List<dynamic> catlist = [];
            map.forEach((key, value) {
              catlist.add(value);
            });
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                // shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: catlist.length,
                itemBuilder: (BuildContext context, int index) {
                  Color randomColor =
                      Color(Random().nextInt(0xFFFFFFFF)).withOpacity(0.8);
                  return Container(
                    decoration: BoxDecoration(
                      color: randomColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        const EdgeInsets.only(right: 14, left: 14, bottom: 8),
                    padding: const EdgeInsets.only(top: 10, left: 10),
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
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            catlist[index]['name']!,
                            style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        //SizedBox(width: 150,),
                        const Spacer(),
                        InkWell(
                          child: Container(
                              child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                          onTap: () {
                            // print('reshika' + catlist[index]['cat_id'].toString());
                            openEditDialog(
                                catlist[index]['image'],
                                catlist[index]['name'],
                                catlist[index]['cat_id'].toString());
                          },
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        InkWell(
                          onTap: () {
                            _deleteProduct(catlist[index]['cat_id'].toString());
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: const Icon(
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
        child: const Icon(Icons.add),
      ),
    );
  }

  void openAddDialog() {
    File? selectedImageFile;

    String categoryName = ''; // To store the category name
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: selectedImageFile != null ? 430 : 250,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    selectedImageFile != null
                        ? Image.file(
                            selectedImageFile!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          )
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
                      child: const Text(
                        'Pick an image',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Add some spacing
                    TextFormField(
                      onChanged: (value) {
                        categoryName = value;
                      },
                      initialValue: categoryName,
                      decoration: InputDecoration(
                          // hintText: 'catlist[index]['name']',
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              addToServer(
                                  selectedImageFile, categoryName, null);
                            },
                            child: const Text('Save'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _deleteProduct(String catId) async {
    showDialog(
      context: context,
      builder: (BuildContext
      context) {
        return AlertDialog(
          title: const Text(
              'Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed:
                  () {
                Navigator.of(
                    context)
                    .pop(); // Close the dialog
              },
              child: Text(
                  'Cancel'),
            ),
            TextButton(
              onPressed:
                  () async {
                try {
                  await dbRef
                      .child(catId)
                      .remove()
                      .then((value) =>
                  {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Category deleted successfully'),
                      backgroundColor: Colors.green,
                    )),
                    Navigator.of(context).pop()
                  });
                } catch (error) {
                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(
                    SnackBar(
                      content:
                      Text('Error deleting category $error'),
                    ),
                  );
                }
              },
              child: Text(
                  'Delete'),
            ),
          ],
        );
      },
    );
  }

  void addToServer(
      File? selectedImageFile, String categoryName, String? catid) {
    if (selectedImageFile != null && categoryName.isNotEmpty) {
      sendImageToFirebase(selectedImageFile, categoryName, catid);
    } else if (categoryName.isNotEmpty) {
      updateName(categoryName, catid);
    }
  }

  void sendImageToFirebase(
      File imgFile, String categoryName, String? catid) async {
    // setState(() {
    //   isClicked = true;
    // });
    final stref = FirebaseStorage.instance.ref('Category');
    var rndNo = DateTime.now().microsecondsSinceEpoch.toString();

    //store image choose from gallary to firebase storage
    await stref.child('image/$rndNo').putFile(File(imgFile.path));

    //get download url of upload image
    var imgUrl = await stref.child('image/$rndNo').getDownloadURL();

    final dbRef = FirebaseDatabase.instance.ref('Category');
    if (catid != null) {
      await dbRef
          .child(catid)
          .update({'image': imgUrl, 'name': categoryName}).whenComplete(() => {
                setState(() {
                  isClicked = false;
                }),
                Navigator.of(context).pop()
              });
    } else {
      await dbRef.child(rndNo).set({
        'image': imgUrl,
        'cat_id': rndNo,
        'name': categoryName
      }).whenComplete(() => {
            setState(() {
              isClicked = false;
            }),
            Navigator.of(context).pop()
          });
    }
  }

  void openEditDialog(String image, String name, String catid) {
    File? selectedImageFile;
    _catNameController.text = name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: 430,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    selectedImageFile == null
                        ? Image.network(
                            image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          )
                        : Image.file(
                            selectedImageFile!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
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
                      child: const Text(
                        'Pick an image',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Add some spacing
                    TextFormField(
                      controller: _catNameController,
                      decoration: InputDecoration(
                          //hintText: 'Enter category name',
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              addToServer(selectedImageFile,
                                  _catNameController.text, catid);
                            },
                            child: const Text('Update'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void updateName(String categoryName, String? catid) async {
    final dbRef = FirebaseDatabase.instance.ref('Category');
    if (catid != null) {
      await dbRef
          .child(catid)
          .update({'name': categoryName}).whenComplete(() => {
                setState(() {
                  isClicked = false;
                }),
                Navigator.of(context).pop()
              });
    }
  }
}
