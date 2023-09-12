import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class MySignup extends StatefulWidget {
  MySignup({Key? key}) : super(key: key);

  @override
  State<MySignup> createState() => _MySignupState();
}

class _MySignupState extends State<MySignup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   toolbarHeight: 0,
      // ),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/hd.jpg'),
      //     fit: BoxFit.cover,opacity: 0.3,
      //   ),
      // ),

      body:
      Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hd.jpg'),
                  fit: BoxFit.cover,
                  opacity: 1,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 35, top: 50),
              child: Text(
                'Create An \nAccount',
                style: GoogleFonts.abel(
                  textStyle: TextStyle(
                      color: Colors.orange,
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0),
                ),
              ),
            ),
            SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.28,
                      left: 35,
                      right: 35),
                  child: Column(children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(width: 1.5, color: Colors.white)),
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(width: 1.5, color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _pwdController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              BorderSide(width: 1.5, color: Colors.white)),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () {

                            if (_formKey.currentState!.validate()) {

                              performMySignup();

                            }
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              backgroundColor: Colors.blue,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?  ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                          onPressed: ()
                          { Navigator.pushNamed(context, 'login'); },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ]),
                )),
          ],
        ),
      ),
    );
  }

  void performMySignup() async {

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _pwdController.text,
      );
      if(userCredential != null){

      await sendDataToFb(userCredential);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Successful'),
              content: Text('Congratulations! You have been registered.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if(e.code == 'weak-password'){
        print('weak-password');
      }
      else if(e.code == 'email-already-in-use'){
        print('email-already-in-use');

      }
      else if(e.code == 'invalid-email'){
        print('your email is badly formatted');
      }
      // print(e);
    }
  }

   sendDataToFb(UserCredential respo) async{
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('Users');
    String id = 'kjkjkjjkhkj';
   await dbRef.child(respo.user!.uid.toString()).set({
      'name' : _nameController.text,
      'email': _emailController.text,
      'password': _pwdController.text,
    }).then((value) {
      Navigator.pushNamed(context, 'login');
    });
  }
}
