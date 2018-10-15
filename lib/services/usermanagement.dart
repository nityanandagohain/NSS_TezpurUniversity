import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement {
  storeNewUser(user, name, rollno) {
    String role = "user";
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'name': name,
      'rollno' : rollno,
      'role': role
    }).catchError((e) {
      print(e);
    });
  }
}
