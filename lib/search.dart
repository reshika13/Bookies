import 'package:bookies/modal/searchModal.dart';
import 'package:bookies/prodesc.dart';
import 'package:bookies/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class MySearch extends StatefulWidget {
  const MySearch({Key? key}) : super(key: key);

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  final dbRef = FirebaseDatabase.instance.ref('Products');
  // List<Map<dynamic, dynamic>> sList = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<dynamic, dynamic>> _searchResults = [];
  bool isBookAvail = false;

  // getAllProducts() async {
  //   final snap = await dbRef.once();
  //   final data = snap.snapshot.value;

  //   if (data is List) {
  //     for (var value in data) {
  //       if (value != null) {
  //         sList.add(value);
  //       }
  //     }
  //   }
  // }

  void _performSearch(String value) async {
    if (value.isEmpty) {
      setState(() {
        isBookAvail = false;
        _searchResults = [];
      });
      return;
    }
    var snap = await dbRef.once();

    final prod = snap.snapshot.value as List;

    if (prod.isNotEmpty) {
      setState(() {
        isBookAvail = true;

        _searchResults = [];
        for (var sp in prod) {
          if (sp != null) {
            if (sp['name']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase())) {
              _searchResults.add(sp);
            }
          }
        }
      });
    } else {
      setState(() {
        isBookAvail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              child: TextField(
                onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
                controller: _searchController,
                onChanged: (value) {
                  Future.delayed(const Duration(seconds: 2))
                      .then((lol) => _performSearch(value));
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff302360),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "e.g: The Alchemist",
                  suffixIcon: const Icon(Icons.search),
                  suffixIconColor: Colors.white,
                ),
              ),
            ),

            // FutureBuilder(
            //   future: getAllProducts(),
            //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     return Expanded(
            //       child: GridView.builder(
            //           gridDelegate:
            //               const SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 2,
            //             mainAxisSpacing: 3.0,
            //           ),
            //           itemCount: sList.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (_) =>
            //                             MyDetail(data: sList[index])));
            //               },
            //               child: Container(
            //                 margin: const EdgeInsets.all(10),
            //                 // padding: const EdgeInsets.all(5),
            //                 decoration: BoxDecoration(
            //                   color: Colors.black,
            //                   borderRadius: BorderRadius.circular(20),
            //                 ),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     ClipRRect(
            //                       borderRadius: BorderRadius.only(
            //                           topLeft: Radius.circular(20),
            //                           topRight: Radius.circular(20)),
            //                       child: Image.network(
            //                         sList[index]['image'],
            //                         fit: BoxFit.fill,
            //                         height: 100,
            //                         width: double.infinity,
            //                       ),
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             sList[index]['name'].toString(),
            //                             style: TextStyle(
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                           SizedBox(
            //                             height: 2,
            //                           ),
            //                           Text(
            //                             'Rs ${sList[index]['price']}',
            //                             style: TextStyle(
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             );
            //           }),
            //     );
            //   },
            // )

            Expanded(
              child: !isBookAvail
                  ? const Center(
                  child: Text(
                    'search your favourite books',
                    style: TextStyle(color: Color(0xff302360)),
                  ))
                  : _searchResults.isEmpty
                  ?  Center(
                  child: Text(
                    'No books found for \n ${_searchController.text}',
                    style: TextStyle(color: Color(0xff302360)),
                  ))
                  : GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3.0,
                ),
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyDetail(
                                  data: _searchResults[index])));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff302360),
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
                              _searchResults[index]['image'],
                              fit: BoxFit.fill,
                              height: 100,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _searchResults[index]['name']
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Rs ${_searchResults[index]['price']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}