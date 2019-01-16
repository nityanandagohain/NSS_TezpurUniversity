import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textEditingController =
      new TextEditingController();

  //Subscribe so that any change in the collection will automatically reflect here
  StreamSubscription<QuerySnapshot> subscription;

  //Data from firestore will be DocumentSnapshot
  List<DocumentSnapshot> chatData;
  int _lengthOfChatData = 0;
  String userName = "";
  String uid = "";

  //Referencing the events collection
  final CollectionReference collectionReference =
      Firestore.instance.collection("chat");

  void initState() {
    super.initState();
    subscription = collectionReference
        .orderBy("timestamp", descending: true)
        .limit(20)
        .snapshots()
        .listen((datasnapshot) {
      setState(() {
        var tChatData = datasnapshot.documents;
        //Sort the data in descending order according to time of creation
        tChatData
            .sort((x, y) => y.data["timestamp"].compareTo(x.data["timestamp"]));
        chatData = tChatData;
        _lengthOfChatData = chatData.length;
      });
    });

    setUserData();
  }

  setUserData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userName = user.displayName;
      uid = user.uid;
    });
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
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
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: _lengthOfChatData,
              reverse: true,
              padding: EdgeInsets.all(6.0),
              itemBuilder: (BuildContext context, int index) {
                Msg msg = new Msg(
                  text: "${chatData[index].data["text"]}",
                  username: "${chatData[index].data["name"]}",
                  animationController: new AnimationController(
                      vsync: this, duration: Duration(milliseconds: 800)),
                );
                msg.animationController.forward();
                return msg;
              },
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      style: TextStyle(color: Colors.blue, fontSize: 15.0),
                      controller: _textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),

                // Button send message
                Material(
                  child: new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 8.0),
                    child: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: handleMessageSubmit,
                      color: Colors.blue,
                    ),
                  ),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleMessageSubmit() async {
    try {
      await collectionReference.add({
        'name': userName,
        'text': _textEditingController.text,
        'uid': uid,
        'timestamp': DateTime.now().toString(),
      }).catchError((err) {
        print("Error $err");
      });
      _textEditingController.clear();
    } catch (err) {
      print("error ocured in ChatPage.dart in handle Message Submit");
    }
  }
}

class Msg extends StatelessWidget {
  Msg({this.username, this.text, this.animationController});
  final String text;
  final String username;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: Container(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$username",
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      "$text",
                      style: TextStyle(
                          fontSize: 11.0, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
