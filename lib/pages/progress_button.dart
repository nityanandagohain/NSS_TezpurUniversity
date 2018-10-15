import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 50.0,
            ),
            Text(
              "Loading!",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30.0,
                  color: Colors.greenAccent),
            )
          ],
        ),
      ),
    );
  }
}
