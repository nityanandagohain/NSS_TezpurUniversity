import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/usermanagement.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final CollectionReference collectionReference =
      Firestore.instance.collection("users");
  StreamSubscription<QuerySnapshot> subscription;

  //Data from firestore will be DocumentSnapshot
  List<DocumentSnapshot> eventsData;
  String _name = "";
  String _rollno = "";
  String _hostel = "";
  bool edit = false;
  List<DocumentSnapshot> userData;
  void saveProfile() async {
    try {
      print("d $_hostel d");
      await UserManagement().updateUserProfile(_name, _rollno, _hostel);
      toggleView();
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        userData = datasnapshot.documents;
        _name = userData[0].data['name'];
        _rollno = userData[0].data['rollno'];
        _hostel = userData[0].data['hostel'];
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      edit = !edit;
    });
  }

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
        child: edit
            ? Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _name,
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
                      initialValue: _rollno,
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
                      initialValue: _hostel,
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
              )
            : Column(
                children: <Widget>[
                  Text(userData[0].data["name"]),
                  Text(userData[0].data["rollno"]),
                  Text(userData[0].data["hostel"]),
                  MaterialButton(
                    child: Text("edit"),
                    onPressed: toggleView,
                  ),
                ],
              ),
      ),
    );
  }
}
