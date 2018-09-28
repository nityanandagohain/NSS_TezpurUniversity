import 'package:flutter/material.dart';

class HomePageAfterLogin extends StatefulWidget {
  @override
  _HomePageAfterLoginState createState() => _HomePageAfterLoginState();
}

class _HomePageAfterLoginState extends State<HomePageAfterLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        //to remove the back button of the navigator
        automaticallyImplyLeading: false, 
      ),
    );
  }
}
