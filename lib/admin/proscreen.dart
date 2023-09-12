import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../productdetails.dart';

class ProScreen extends StatefulWidget {
  ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  final ImagePicker picker = ImagePicker();
  final dbRef = FirebaseDatabase.instance.ref('Products');
  bool isClicked = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: dbRef.onValue,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Text('no data');
            } else {
              List<Map<dynamic, dynamic>> prodList = [];
              var data = snapshot.data.snapshot.value;
              for (var value in data) {
                if (value != null) {
                  prodList.add(value);
                }
              }
              // print('productlength : ${prodList[0]['name']}');
              return prodList.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 3.0,
                          ),
                          itemCount: prodList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            MyDetail(data: prodList[index])));
                              },
                              child: Container(
                                height: 400,
                                margin: const EdgeInsets.all(10),
                                // padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      child: Image.network(
                                        prodList[index]['image'],
                                        fit: BoxFit.fill,
                                        height: 100,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  prodList[index]['name']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  'Rs ${prodList[index]['price']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      child: Icon(Icons.edit),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      child: Icon(Icons.delete),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : const Center(child: Text('No Books Found'));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the button press here
          addProducts();
        },
        child: const Icon(Icons.add),
      ),
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

  void addProducts() {
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
                        categoryName = value; // Update the category name
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

  void addToServer(File? selectedImageFile, String categoryName, param2) {}
}