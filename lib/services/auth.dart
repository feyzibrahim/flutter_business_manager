import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:business_manager/home.dart';
import 'package:business_manager/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/pages/authentication/authentication.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget checkLoggedIn() {
    if (_auth.currentUser == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }

  Future signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      var user = Users(email: email, name: name, uid: userCredential.user.uid);
      _createUserinFireStore(user);
      _createFirstTransactions(userCredential.user.uid);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('No user found for that email.');
      return null;
    }
  }

  Future _createUserinFireStore(Users users) async {
    final userCollection =
        FirebaseFirestore.instance.collection('User').doc(users.uid);
    return await userCollection.set({
      'uid': users.uid,
      'email': users.email,
      'name': users.name,
    });
  }

  Future _createFirstTransactions(String uid) async {
    final transactionCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Transaction');

    final docId = transactionCollection.doc().id;

    final timestamp = Timestamp.now();

    return await transactionCollection.doc(docId).set({
      'initialBal': 0,
      'finalBal': 0,
      'date': CommenService().getDate(),
      'id': docId,
      'timestamp': timestamp,
    });
  }

  String getUid() {
    return _auth.currentUser.uid;
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}
