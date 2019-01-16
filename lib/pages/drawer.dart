import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nss_tezu/pages/chatPage.dart';
import 'login_page.dart';
import 'dart:async';

Widget customDrawer(context) {
  Future<String> _getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.displayName;
  }

  Future<String> _getUserPhoto() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.photoUrl;
  }

  return Drawer(
    child: Stack(
      children: <Widget>[
        ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: _getUserPhoto(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null) {
                        return Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(snapshot.data),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 90.0,
                          height: 90.0,
                        );
                      }
                    },
                  ),
                  FutureBuilder(
                    future: _getUser(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Text(
                        "Welcome ${snapshot.data}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                      );
                    },
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Chat'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage()));
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
        Positioned(
          bottom: 20.0,
          left: 50.0,
          child: Text(
            "Developed by Nityananda Gohain",
            overflow: TextOverflow.clip,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
