import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../productdetails.dart';

class ProScreen extends StatefulWidget {
  ProScreen ({super.key, required this.cat});

  Map<dynamic,dynamic> cat;
 // Map<dynamic,dynamic> pro;
  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  final dbRef = FirebaseDatabase.instance.ref('Product');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<dynamic>snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator(),);
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data.snapshot.value == null) {
            return Text('No data');
          }
          else if(!snapshot.hasData){
            return Text('no data');
          }
          else{
            List<dynamic>mapList = snapshot.data.snapshot.value.toList();
            mapList.removeAt(0);
            List<dynamic>prodList = [];
            for(var element in mapList){
              if(element['cat_id']
                  .toString()
                  .contains(widget.cat['cat_id'].toString())){
                prodList.add(element);
              }
            }
            // print('productlength : ${prodList[0]['name']}');
            return prodList.isNotEmpty ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3.0,
                  ),
                  itemCount: prodList.length,
                  itemBuilder: (BuildContext context,int index)
                  {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>MyDetail(data:prodList[index])));

                      },
                      child: Container(
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
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(  prodList[index]['name'].toString(),
                                    style: TextStyle(
                                      color: Colors.white,

                                    ),
                                  ),
                                  SizedBox(height: 2,),
                                  Text('Rs ${prodList[index]['price']}',
                                    style: TextStyle(
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
                  }
              ),
            ) : Center(child: Text('No Books Found'));
          }
        }

    ),

    );
  }
}
