import 'package:flutter/material.dart';
import 'package:nss_tezu/pages/home.dart';
import 'package:nss_tezu/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

var user;
void main() async {
  user = await FirebaseAuth.instance.currentUser();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NSS TU",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Check if the user is already logged in
      // If yess show home page
      // Else show login page
      home: (user == null)
          ? LoginPage()
          : HomePageAfterLogin(),
    );
  }
}
