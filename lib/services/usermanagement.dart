import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagement {
  storeNewUser(user, name, rollno) {
    String role = "user";
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'name': name,
      'rollno': rollno,
      'role': role
    }).catchError((e) {
      print(e);
    });
  }

  //This function will return true if the user is an admin
  Future<bool> checkIfAdmin() async {
    print("in check admin ...............................................");
    var user = await FirebaseAuth.instance.currentUser();
    var docs = await Firestore.instance
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();

    //Iterating throught the document in the users collection
    //and check if the user uid is equal to the document uid
    //then check if the user role is admin
    if (docs.documents[0].exists) {
      if (docs.documents[0].data['role'] == "admin") {
        //The user is an admin
        return true;
      }
    }
    return false;
  }
}
