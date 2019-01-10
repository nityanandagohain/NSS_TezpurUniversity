import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagement {
  Future storeNewUser(user) async {
    try {
      bool exist = await checkIfAlreadyExist();
      if (!exist) {
        String role = "user";
        Firestore.instance.collection('/users').add({
          'email': user.email,
          'uid': user.uid,
          'name': user.displayName,
          'role': role,
          'firebaseToken': ""
        }).catchError((e) {
          print(e);
        });
      } else {
        print("User already exist!");
      }
    } catch (err) {
      print("asdadsad $err");
    }
  }

  Future addFirebaseMessagingToken(firebaseToken) async {
    try {
      var user = await FirebaseAuth.instance.currentUser();
      var docs = await Firestore.instance
          .collection("/users")
          .where("uid", isEqualTo: user.uid)
          .getDocuments();
      if (docs.documents[0].exists) {
        print(docs.documents[0].documentID);
        await Firestore.instance
            .collection("/users")
            .document(docs.documents[0].documentID)
            .updateData({"firebaseToken": firebaseToken});
      }
    } catch (err) {
      print("Error occured in storing firebase messaging token");
    }
  }

  //This function will return true if the user is an admin
  Future<bool> checkIfAdmin() async {
    var user = await FirebaseAuth.instance.currentUser();
    var docs = await Firestore.instance
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    if (docs.documents[0].exists) {
      if (docs.documents[0].data['role'] == "admin") {
        return true;
      }
    }
    return false;
  }

  Future<bool> checkIfAlreadyExist() async {
    var user = await FirebaseAuth.instance.currentUser();
    var docs = await Firestore.instance
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    try {
      if (docs.documents[0].exists) {
        return true;
      }
    } catch (err) {
      print(err);
    }
    return false;
  }
}
