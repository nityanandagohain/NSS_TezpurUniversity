import 'package:flutter/material.dart';

//Firebase Packages
import 'package:firebase_auth/firebase_auth.dart';

//Pages
import 'package:nss_tezu/pages/home.dart';
import 'package:nss_tezu/pages/progress_button.dart';
import 'package:nss_tezu/services/usermanagement.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _rollno;
  String _name;

  FormType _formType = FormType.login;

  bool showProgressButton = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_email.length < 5 || _password.length < 5) {
        showError("Password length is small");
        return false;
      } else {
        if (_formType == FormType.register &&
            (_rollno.length < 6 || _name.length < 4)) {
          showError("Rollno OR name is not valid");
          return false;
        }
        print("Valid $_email $_password");
        return true;
      }
    } else {
      print("Invalid $_email $_password s");
    }
    return false;
  }

  //This function inturn calls validate and save and after that uses firebase to authenticate
  hideProgress() {
    setState(() {
      showProgressButton = false;
    });
  }

  validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        showProgressButton = true;
      });
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          print("Signed In: ${user.uid}");
          hideProgress();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePageAfterLogin()));
        } else {
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password);
          print("Registered : ${user.uid}");

          //Store the user data in firebase
          UserManagement().storeNewUser(user, _name, _rollno);

          hideProgress();
          moveToLogin();
        }
      } catch (err) {
        await hideProgress();
        print("Error xyz: $err");
        // showError("Error! Enter correct email and password");
      }
    }
  }

  //Show a snackbar at the bottom
  showError(String error) {
    final snackbar = SnackBar(
      content: new Text(error),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  //change from LOGIN to CREATE ACCOUNT
  moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  //Change form CREATE ACCOUNT to LOGIN
  moveToLogin() {
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showProgressButton == true
        ? ProgressButton()
        : Scaffold(
            key: scaffoldKey,
            body: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(35.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: tuText() +
                          buildInputs() +
                          inputsForSignUp() +
                          buildSubmitButtons(),
                    ),
                  ),
                ),
              ],
            ));
  }

  //TOP TEXT
  List<Widget> tuText() {
    if (_formType == FormType.login) {
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
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
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
    } else {
      return [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "SIGN UP",
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
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
        SizedBox(
          height: 50.0,
        )
      ];
    }
  }

  //EMAIL AND PASSWORD INPUT
  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: "EMAIL",
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        onSaved: (value) => _email = value,
      ),
      SizedBox(
        height: 20.0,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: "PASSWORD",
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
      // SizedBox(
      //   height: 5.0,
      // ),
      // Container(
      //   alignment: Alignment.bottomRight,
      //   padding: EdgeInsets.only(top: 15.0, left: 20.0),
      //   child: InkWell(
      //     child: Text(
      //       "Forgot Password",
      //       style: TextStyle(
      //           color: Colors.green,
      //           fontWeight: FontWeight.bold,
      //           fontFamily: 'Montserrat',
      //           decoration: TextDecoration.underline),
      //     ),
      //   ),
      // ),
      SizedBox(
        height: 40.0,
      ),
    ];
  }

  //INPUT FOR ROLLNO AND NAME WHILE SIGNUP
  List<Widget> inputsForSignUp() {
    if (_formType == FormType.login) {
      return [];
    } else {
      return [
        TextFormField(
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
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: "RollNo",
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
        SizedBox(
          height: 20.0,
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        Container(
          height: 50.0,
          child: InkWell(
            onTap: validateAndSubmit,
            child: Material(
              borderRadius: BorderRadius.circular(40.0),
              shadowColor: Colors.greenAccent,
              color: Colors.green,
              elevation: 7.0,
              child: Center(
                child: Text(
                  "LOGIN",
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
        SizedBox(
          height: 40.0,
        ),
        FlatButton(
          child: Text(
            "Create Account",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        Container(
          height: 40.0,
          child: InkWell(
            onTap: validateAndSubmit,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.greenAccent,
              color: Colors.green,
              elevation: 7.0,
              child: Center(
                child: Text(
                  "CREATE ACCOUNT",
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
        FlatButton(
          child: Text(
            "Have an Account? Login",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
