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
List<Map<dynamic,dynamic>> sList = [];

   getAllProducts() async{
  final snap = await dbRef.once();
  final data = snap.snapshot.value;

  if (data is List) {
    for (var value in data) {
      if(value != null){
        sList.add(value);
      }
    }
  }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1f1545),
      appBar: AppBar(
        backgroundColor: Color(0xFF1f1545),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: TextField(
              onChanged: (searchValue)
              {
                for(var element in sList){
                  if(element['name']
                      .toString()
                      .contains(searchValue)){
                      sList.clear();
                      sList.add(element);
                  }
                }
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
                suffixIconColor: Colors.purple.shade900,
              ),
            ),
          ),
         FutureBuilder(
           future: getAllProducts(),
           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
             if(snapshot.connectionState == ConnectionState.waiting){
               return const Center(child: CircularProgressIndicator());
             }
           return Expanded(
           child: GridView.builder(
           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           mainAxisSpacing: 3.0,
           ),
           itemCount: sList.length,
           itemBuilder: (BuildContext context,int index)
           {
           return InkWell(
           onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (_)=>MyDetail(data:sList[index])));
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
           sList[index]['image'],
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
           Text(  sList[index]['name'].toString(),
           style: TextStyle(
           color: Colors.white,

           ),
           ),
           SizedBox(height: 2,),
           Text('Rs ${sList[index]['price']}',
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
           );
         },)
        ],
      )
   );
  }
}
