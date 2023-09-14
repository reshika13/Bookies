import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                            return Container(
                              height: 500,
                              //   padding: const EdgeInsets.all(0.05),
                              margin: const EdgeInsets.all(10),
                              // padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SingleChildScrollView(
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
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        performEdit(
                                                            prodList[index]);
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      )),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Confirm Delete'),
                                                              content: Text(
                                                                  'Are you sure you want to delete this product?'),
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
                                                                          .child(prodList[index]['product_id']
                                                                              .toString())
                                                                          .remove()
                                                                          .then((value) =>
                                                                              {
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                  content: Text('Product deleted successfully'),
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
                                                                              Text('Error deleting product $error'),
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
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color:
                                                            Colors.red.shade400,
                                                      ))
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

  void performEdit(Map<dynamic, dynamic> data) {
    File? selectedImageFile;
    String name = data['name'];
    String price = data['price'].toString();
    String desc = data['description'];
    String publisher = data['publisher'];
    String publishedAt = data['publishedAt'].toString();
    String productId = data['product_id'].toString();
    String image = data['image'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: 720,
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
                      onChanged: (value) {
                        name = value;
                      },
                      initialValue: name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(height: 20), // Add some spacing
                    TextFormField(
                      onChanged: (value) {
                        price = value;
                      },
                      initialValue: price,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(height: 20), // Add some spacing
                    TextFormField(
                      onChanged: (value) {
                        desc = value;
                      },
                      initialValue: desc,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        publisher = value;
                      },
                      initialValue: publisher,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        publishedAt = value;
                      },
                      initialValue: publishedAt,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              updateProduct(selectedImageFile, name, price,
                                  desc, publishedAt, publisher, productId);
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

  performDelete(String productId) async {
    try {
      await dbRef.child(productId).remove().then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Product deleted successfully'),
            )),
            Navigator.of(context).pop()
          });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product'),
        ),
      );
    }
  }

  void updateProduct(File? selectedImageFile, String name, String price,
      String desc, String publishedAt, String publisher, String productId) {
    if (selectedImageFile != null &&
        name.isNotEmpty &&
        price.isNotEmpty &&
        desc.isNotEmpty &&
        publishedAt.isNotEmpty &&
        publisher.isNotEmpty) {
      sendImageToFirebase(selectedImageFile, name, price, desc, publishedAt,
          publisher, productId);
    } else if (selectedImageFile == null &&
        name.isNotEmpty &&
        price.isNotEmpty &&
        desc.isNotEmpty &&
        publishedAt.isNotEmpty &&
        publisher.isNotEmpty) {
      sendImageToFirebase(
          null, name, price, desc, publishedAt, publisher, productId);
    }
  }

  void sendImageToFirebase(
      File? imgFile,
      String name,
      String price,
      String desc,
      String publishedAt,
      String publisher,
      String productId) async {
    final stref = FirebaseStorage.instance.ref('Products');
    var rndNo = DateTime.now().microsecondsSinceEpoch.toString();
    print('reshika $imgFile');

    Map<String, dynamic> prodData = {
      'name': name,
      'price': price,
      'description': desc,
      'publishedAt': publishedAt,
      'publisher': publisher
    };

    if (imgFile != null) {
      //store image choose from gallary to firebase storage
      await stref.child('image/$rndNo').putFile(File(imgFile.path));

      //get download url of upload image
      var imgUrl = await stref.child('image/$rndNo').getDownloadURL();
      prodData['image'] = imgUrl;
    }

    await dbRef.child(productId).update(prodData).whenComplete(() => {
          setState(() {
            isClicked = false;
          }),
          Navigator.of(context).pop()
        });
  }
}
