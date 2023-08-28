// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// class MyCart extends StatefulWidget {
//   const MyCart({Key? key}) : super(key: key);
//
//   @override
//   State<MyCart> createState() => _MyCartState();
// }
//
// class _MyCartState extends State<MyCart> {
//   final dbRef = FirebaseDatabase.instance.ref('products');
// List <Map<String, dynamic>> cartItems = [];
//
//   @override
//   void initState(){
//     super.initState();
//     fetchCartItems();
//   }
//
//
//
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Cart'),),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//                 child: ListView.builder(itemBuilder: (context, index){
//
//       }));
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement the logic to proceed to checkout
//               },
//               child: Text('Proceed to Checkout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void fetchCartItems() {
//     dbRef.once().then((DatabaseEvent snapshot) {
//       DataSnapshot data = snapshot.snapshot;
//       Map<dynamic, dynamic> itemsMap = data.value;
//       if (itemsMap != null) {
//         List<Map<String, dynamic>> items = [];
//         itemsMap.forEach((key, value) {
//           items.add(Map<String, dynamic>.from(value));
//         });
//         setState(() {
//           cartItems = items;
//         });
//       }
//     }).catchError((error) {
//       print("Error fetching cart items: $error");
//     });
//   }
// }
