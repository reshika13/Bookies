import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bookies/cartprovider.dart';
import 'package:provider/provider.dart';


class NewCheckout extends StatefulWidget {
  const NewCheckout({Key? key}) : super(key: key);

  @override
  State<NewCheckout> createState() => _NewCheckoutState();
}

class _NewCheckoutState extends State<NewCheckout> {
  final _formKey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.ref('Orders');
  late CartProvider cartProvider;
  final auth = FirebaseAuth.instance;


  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      if (auth.currentUser != null) {
        Provider.of<CartProvider>(context, listen: false).getAllCart();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Check out',
            style: TextStyle(
              color: Colors.white,
            ),),
        ),
        body: Form(
          // key: _formKey,
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Address',
                      hintText: 'Enter your address',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(width: 1.5, color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    // fillColor: Colors.black38,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Phone number',
                      hintText: 'Enter your phone number',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(width: 1.5, color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(height: 40,),
                Text('Grand Total: Nrs ${cartProvider.totalSum.toString()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 50,),
                Container(
                  height: 100,
                  width: 300,
                  padding: EdgeInsets.all(25),
                  color: Colors.yellow.shade900,
                  child: Column(
                    children: [
                      Text('Payment Method:',
                        style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,

                        ),),
                      SizedBox(height: 10,),
                      Text('Cash on Delivery',
                        style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),)
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: (){
                    confirmDialog();
                  },
                  child: Text('Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],

            ),
          ),

        )

    );
  }

  void confirmDialog() {
    showDialog(
        context: context, builder: (context){
          return AlertDialog(
          title: Text('Confirm Order'),
            content: Text('Are you sure you want to confirm this order?'),
            actions: [
              TextButton(onPressed: (){
                //some logic
                sendOrderToFirebase();
                print('Order Confirmed');
                Navigator.of(context).pop();
              },
                  child: Text('Confirm')),
              SizedBox(width: 10,),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              },
                  child: Text('Cancel'))
            ],
          );
    }
    );
  }

  void sendOrderToFirebase() {
 //   dbRef
  }
}
