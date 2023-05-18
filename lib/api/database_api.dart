import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eds_beta/models/user_model.dart';

abstract class IDatabaseAPI {
  Future<void> getUserDataFromDB({required String uid});
}

class DatabaseAPI extends IDatabaseAPI {
  final FirebaseFirestore _firestore;
  DatabaseAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  Future<void> getUserDataFromDB({required String uid}) async {
    try {
      await _firestore.collection('users').doc(uid).get().then((value) {
        if (value.exists) {
          log("User exists");
          log(value.data().toString());
          // return UserModel.fromMap(value.data()!);
        } else {
          log("User does not exist");
          // return null;
        }
      });
    } catch (e) {}
  }
}
