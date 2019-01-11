import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _name = "";
  String _rollno = "";
  String _hostel = "";
  void saveProfile() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NSS TEZU",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: MaterialButton(
          child: Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Roll No",
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onSaved: (value) => _rollno = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Hostel",
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onSaved: (value) => _hostel = value,
              ),
              MaterialButton(
                child: Text("SUBMIT"),
                color: Colors.greenAccent,
                onPressed: saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
