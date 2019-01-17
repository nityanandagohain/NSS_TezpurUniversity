import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _rollno = "";
  String _hostel = "";
  FirebaseUser user;
  bool edit = false;
  List<DocumentSnapshot> userData = [];
  void saveProfile() async {
    try {
      final form = _formKey.currentState;
      form.save();
      print("d $_name/ $_rollno/ $_hostel d");
      await UserManagement().updateUserProfile(_name, _rollno, _hostel);
      toggleView();
    } catch (err) {
      print(err);
    }
  }

  void getUid() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    super.initState();
    getUid();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      userData = datasnapshot.documents;
      for (var i = 0; i < userData.length; i++) {
        if (userData[i].data['uid'] == user.uid) {
          setState(() {
            _name = userData[i].data['name'];
            _rollno = userData[i].data['rollno'];
            _hostel = userData[i].data['hostel'];
          });
        }
      }
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
            ? ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Form(
                      key: _formKey,
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
                          SizedBox(
                            height: 20.0,
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
                ],
              )
            : userData == []
                ? Container()
                : Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          _name,
                          style: textDisplayStyle(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          _rollno,
                          style: textDisplayStyle(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          _hostel,
                          style: textDisplayStyle(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        MaterialButton(
                          child: Text(
                            "EDIT",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: toggleView,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  TextStyle textDisplayStyle() {
    return TextStyle(
        color: Colors.black,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w500,
        fontSize: 18.0);
  }
}
