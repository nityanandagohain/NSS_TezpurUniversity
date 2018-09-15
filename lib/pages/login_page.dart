import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_email.length < 5 || _password.length < 5) {
        showLoginError();
        return false;
      } else {
        print("Valid $_email $_password");
        return true;
      }
    } else {
      print("Invalid $_email $_password s");
    }
    return false;
  }

  validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          print("Signed In: ${user.uid}");
        } else {
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password);
          print("Registered : ${user.uid}");
        }
      } catch (err) {
        print("Error: $err");
      }
    }
  }

  showLoginError() {
    final snackbar = SnackBar(
      content: new Text("Enter proper Email and Password!"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  moveToLogin() {
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("NSS TU"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: "Email"),
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text(
            "LOGIN",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: validateAndSubmit,
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
        RaisedButton(
          child: Text(
            "Create Account",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: validateAndSubmit,
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
