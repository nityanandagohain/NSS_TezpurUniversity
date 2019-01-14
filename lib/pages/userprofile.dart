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
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _rollno = "";
  String _hostel = "";
  bool edit = false;
  List<DocumentSnapshot> userData=[];
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
            ? Padding(
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
            )
            : Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      userData[0].data["name"],
                      style: textDisplayStyle(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      userData[0].data["rollno"],
                      style: textDisplayStyle(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      userData[0].data["hostel"],
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
