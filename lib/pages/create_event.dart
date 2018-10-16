import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final CollectionReference collectionReference =
      Firestore.instance.collection('events');

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _info = "";
  addEvent() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_info.length > 0 && _title.length > 0) {
        await collectionReference.add({
          'info': _info,
          'title': _title,
        }).catchError((err) {
          print("Error $err");
        });
        Navigator.pop(context);
      } else {
        print("Error");
        showError("Enter Proper Event Data");
      }
    }
  }

  //Show a snackbar at the bottom
  showError(String error) {
    final snackbar = SnackBar(
      content: new Text(error),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("CREATE EVENT"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(35.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "TITLE",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    onSaved: (value) => _title = value,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "INFOMATION",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    onSaved: (value) => _info = value,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  MaterialButton(
                    child: Text("SUBMIT"),
                    color: Colors.greenAccent,
                    onPressed: addEvent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
