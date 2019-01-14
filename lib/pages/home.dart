import 'dart:async';
import 'dart:math';
import 'dart:core';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

//Firebase packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nss_tezu/pages/create_event.dart';
import 'package:nss_tezu/pages/drawer.dart';

//Pages
import 'package:nss_tezu/services/usermanagement.dart';
import 'package:nss_tezu/pages/userprofile.dart';

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
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        var tEventsData = datasnapshot.documents;
        //Sort the data in descending order according to time of creation
        tEventsData.sort((x,y)=>y.data["dateTimeCreated"].compareTo(x.data["dateTimeCreated"]));
        eventsData = tEventsData;
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

  String getDateTimeStr(String str) {
    var _dateFormat = DateFormat("M/d/yy  h:mma");
    DateTime _dateTime = DateTime.parse(str);
    return _dateFormat.format(_dateTime);
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: customDrawer(context),
      appBar: AppBar(
        title: Text(
          "NSS TEZU",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => UserProfile()));
            },
          )
        ],
        backgroundColor: Colors.white,
        leading: MaterialButton(
          child: Icon(
            Icons.view_headline,
            color: clr,
          ),
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      key: scaffoldKey,
      body: AnimatedContainer(
        padding: EdgeInsets.only(left: 20.0),
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
        color: clr,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
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
              padding: const EdgeInsets.only(top: 50.0),
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
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      getDateTimeStr(eventsData[index]
                                          .data['dateTimeCreated']),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text("VENUE:"),
                                      Text(
                                          "Location: ${eventsData[index].data['venueLocation']}"),
                                      Text(
                                          "At: ${getDateTimeStr(eventsData[index].data['dateTimeVenue'])}")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CreateEvent()));
            },
            child: Center(
              child: Icon(Icons.add),
            ),
          )
        : Container();
  }
}
