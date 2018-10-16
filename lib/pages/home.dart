import 'dart:async';
import 'dart:math';
import 'dart:core';
import 'package:flutter/rendering.dart';

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

class _HomePageAfterLoginState extends State<HomePageAfterLogin>
    with TickerProviderStateMixin {
  PageController pageViewController;
  String str;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //Check if the user is admin
  bool _isAdmin = false;

  //Subscribe so that any change in the collection will automatically reflect here
  StreamSubscription<QuerySnapshot> subscription;

  //Data from firestore will be DocumentSnapshot
  List<DocumentSnapshot> eventsData;
  int _lengthOfEventsData = 0;

  //Referencing the events collection
  final CollectionReference collectionReference =
      Firestore.instance.collection("events");

  Color clr = Colors.orange;
  var pos = 20.0;
  int currentPage = 0;
  double pageOffset = 0.0;
  double currentOffset = 0.0;
  var dir = ScrollDirection.reverse;
  List _colors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.blueGrey,
    Colors.deepOrangeAccent,
    Colors.limeAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.purple,
    Colors.redAccent
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        eventsData = datasnapshot.documents;
        _lengthOfEventsData = eventsData.length;
      });
    });

    //Check if the user is admin if yes then allow
    //creating events
    UserManagement().checkIfAdmin().then((value) {
      setState(() {
        _isAdmin = value;
      });
    });

    pageViewController = new PageController(initialPage: 0);
    setState(() {
      Random rnd;
      rnd = new Random();
      int r = 0 + rnd.nextInt(_colors.length - 0);
      clr = _colors[r];
    });
    pageViewController.addListener(() {
      dir = pageViewController.position.userScrollDirection;
      currentPage = pageViewController.page.truncate();
      currentOffset = pageViewController.offset;
      pageOffset = pageViewController.position.extentInside * currentPage;
      setState(() {
        pos = getMappedValue(0.0, pageViewController.position.extentInside,
            20.0, 100.0, pageViewController.offset - pageOffset);
      });
    });
  }

  double getMappedValue(double range1low, double range1high, double range2low,
      double range2high, double number) {
    return ((number - range1low) *
            ((range2high - range2low) / (range1high - range1low))) +
        range2low;
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
    return new Scaffold(
      drawer: drawerLeft(),
      appBar: AppBar(
          title: Text("NSS TU",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
          backgroundColor: Colors.white,
          leading: MaterialButton(
            child: Icon(
              Icons.view_headline,
              color: Colors.black,
            ),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
          )),
      key: scaffoldKey,
      body: AnimatedContainer(
        padding: EdgeInsets.only(top: 50.0),
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
        color: clr,
        child: PageView.builder(
          itemCount: _lengthOfEventsData,
          onPageChanged: (int page) {
            this.setState(() {
              Random rnd;
              rnd = new Random();
              int r = 0 + rnd.nextInt(_colors.length - 0);
              clr = _colors[r];
            });
          },
          controller: pageViewController,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    height:
                        MediaQuery.of(scaffoldKey.currentContext).size.height -
                            180.0,
                    width:
                        MediaQuery.of(scaffoldKey.currentContext).size.width -
                            40.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          width: MediaQuery.of(scaffoldKey.currentContext)
                                  .size
                                  .width -
                              100.0,
                          left: index != currentPage
                              ? getMappedValue(20.0, 100.0, 160.0, 20.0, pos)
                              : getMappedValue(20.0, 100.0, 20.0, -120.0, pos),
                          top: 20.0,
                          child: Opacity(
                            opacity: index != currentPage
                                ? getMappedValue(20.0, 100.0, 0.0, 01.0, pos)
                                : getMappedValue(20.0, 100.0, 01.0, 00.0, pos),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${eventsData[index].data['title'].toUpperCase()}',
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'T',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    '${eventsData[index].data['info']}',
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: index != currentPage
                              ? getMappedValue(20.0, 100.0, 160.0, 20.0, pos)
                              : getMappedValue(20.0, 100.0, 20.0, -120.0, pos),
                          bottom: 20.0,
                          child: Opacity(
                            opacity: index != currentPage
                                ? getMappedValue(20.0, 100.0, 0.0, 0.4, pos)
                                : getMappedValue(20.0, 100.0, 0.4, 00.0, pos),
                            child: Text(
                              '${eventsData[index].data['title']}',
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 130.0, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: index != currentPage
                        ? getMappedValue(20.0, 100.0, -120.0, -10.0, pos)
                        : getMappedValue(20.0, 100.0, -10.0, 120.0, pos),
                    bottom: 100.0,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1539635098943-31bab121ea34?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a966c23b465cfcf82fb1e88a1bce9eff&auto=format&fit=crop&w=1350&q=80',
                      height: 240.0,
                      width: 240.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: ifAdmin(),
    );
  }

  Widget ifAdmin() {
    return _isAdmin
        ? FloatingActionButton(
            onPressed: () {
              //Go to add new event page
            },
            child: Center(
              child: Icon(Icons.add),
            ),
          )
        : Container();
  }

  Widget drawerLeft() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
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
}
