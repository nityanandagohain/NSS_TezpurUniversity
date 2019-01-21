import 'package:flutter/material.dart';
import 'dart:async';

//Firebase Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//Pages
import 'package:nss_tezu/pages/home.dart';
import 'package:nss_tezu/pages/progress_button.dart';
import 'package:nss_tezu/services/usermanagement.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  String firebaseToken = "";
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print("onLaunch called");
    }, onMessage: (Map<String, dynamic> msg) {
      print("onMessage called");
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called");
    });
    _firebaseMessaging.getToken().then((token) {
      this.setState(() {
        print("Firebase Messaging token: $token");
        firebaseToken = token;
      });
    });
  }

  toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  Future _signIn() async {
    try {
      toggleLoading();
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      FirebaseUser user = await _auth.signInWithGoogle(
          idToken: gSA.idToken, accessToken: gSA.accessToken);
      print("use name ${user.displayName} uid: ${user.uid}");

      //stores only once the user data in firestore
      await UserManagement().storeNewUser(user);
      await UserManagement().addFirebaseMessagingToken(firebaseToken);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomePageAfterLogin()));
    } catch (err) {
      toggleLoading();
      print("Error google sign in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: loading
          ? ProgressButton()
          : ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(35.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: tuText() + buildSubmitButtons(),
                  ),
                ),
              ],
            ),
    );
  }

  //TOP TEXT
  List<Widget> tuText() {
    return [
      Container(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: Text(
          "NSS",
          style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Tezpur",
              style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "University",
                  style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  ".",
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      Center(
        heightFactor: 5.0,
        child: Container(
          height: 50.0,
          child: InkWell(
            onTap: () =>
                _signIn().catchError((e) => print("Error in signIn $e")),
            child: Material(
              borderRadius: BorderRadius.circular(40.0),
              shadowColor: Colors.greenAccent,
              color: Colors.green,
              elevation: 7.0,
              child: Center(
                child: Text(
                  "LOGIN WITH GOOGLE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 40.0,
      ),
      Center(
        child: Text(
          "Developed by Nityananda Gohain",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
        ),
      )
    ];
  }
}
