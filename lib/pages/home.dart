import 'dart:async';

//Firebase packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Pages
import 'package:nss_tezu/pages/login_page.dart';
import 'package:nss_tezu/services/usermanagement.dart';

class HomePageAfterLogin extends StatefulWidget {
  @override
  _HomePageAfterLoginState createState() => _HomePageAfterLoginState();
}

class _HomePageAfterLoginState extends State<HomePageAfterLogin> {
  //Check if the user is admin
  bool _isAdmin = false;


  //Subscribe so that any change in the collection will automatically reflect here
  StreamSubscription<QuerySnapshot> subscription;

  //Data from firestore will be DocumentSnapshot
  List<DocumentSnapshot> eventsData;

  //Referencing the events collection
  final CollectionReference collectionReference =
      Firestore.instance.collection("events");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        eventsData = datasnapshot.documents;
      });
    });

    //Check if the user is admin if yes then allow 
    //creating events
    UserManagement().checkIfAdmin().then((value){
      setState(() {
              _isAdmin = value;
              print("sssssssssssssssssssssssssss $_isAdmin");
            });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //if subscription is not null then cancel it
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NSS Tezpur University"),
        backgroundColor: Colors.orange.shade200,
        //to remove the back button of the navigator
        automaticallyImplyLeading: false,
        elevation: 3.0,
      ),

      //Cards for the events to be displayed
      body: eventsData != null
          ? ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: eventsData.length,
              // itemCount: eve,
              itemBuilder: (BuildContext context, int index) {
                return eventCard(eventsData[index]);
              },
            )
          : Container(),
          floatingActionButton: ifAdmin()
      ,
    );
  }
  Widget ifAdmin(){
    return _isAdmin? FloatingActionButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            print("Signed out");
            // Navigator.pop(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } catch (e) {
            print("Error Signing out");
          }
        },
        child: Text("Sign Out"),
      ):Container();
  }

  Widget eventCard(event) {
    return Container(
      height: 180.0,
      color: Colors.orange,
      margin: EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: <Widget>[
          Text("${event.data['title']}"),
          // Text("${event.data['time']}"),
          Text("${event.data['info']}"),
        ],
      ),
    );
  }
}
