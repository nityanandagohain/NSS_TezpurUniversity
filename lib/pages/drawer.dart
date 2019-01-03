import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'dart:async';

Widget customDrawer(context) {
  Future<String> _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.displayName;
  }
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: FutureBuilder(
            future: _getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return Text("Welcome ${snapshot.data}",style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0,fontWeight: FontWeight.w400),);
            },
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Sign Out'),
          onTap: () async {
            try {
              await FirebaseAuth.instance.signOut();
              print("Signed out");
              // Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            } catch (e) {
              print("Error Signing out");
            }
          },
        ),
      ],
    ),
  );
}
