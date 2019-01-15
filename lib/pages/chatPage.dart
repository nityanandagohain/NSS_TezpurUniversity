import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController =
      new TextEditingController();
  @override
  void initState() {
    super.initState();
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
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400.0,
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('chat')
                    .orderBy('timestamp', descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        return Container(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              children: <Widget>[
                                Text(
                                    "${snapshot.data.documents[index].data["name"]}"),
                                Text(
                                    "${snapshot.data.documents[index].data["text"]}"),
                              ],
                            ));
                      },
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                    );
                  }
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      child: TextField(
                        style: TextStyle(color: Colors.blue, fontSize: 15.0),
                        controller: textEditingController,
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
                        onPressed: () => {},
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
      ),
    );
  }
}
