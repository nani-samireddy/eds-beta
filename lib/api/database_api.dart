import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eds_beta/constants/constans.dart';
import 'package:eds_beta/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseAPIProvider = Provider<DatabaseAPI>((ref) {
  final db = FirebaseFirestore.instance;
  return DatabaseAPI(firestore: db);
});

abstract class IDatabaseAPI {
  Future<UserModel?> getUserDataFromDB({required String uid});
  Future<void> createUserDoc({required UserModel userModel});
}

class DatabaseAPI extends IDatabaseAPI {
  final FirebaseFirestore _firestore;
  DatabaseAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  Future<UserModel?> getUserDataFromDB({required String uid}) async {
    try {
      await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          log("User exists");
          log(value.data().toString());
          return UserModel.fromMap(value.data()!);
        } else {
          log("User does not exist");
          //TODO:Create new user
          return null;
        }
      });
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<void> createUserDoc({required UserModel userModel}) async {
    await _firestore
        .collection(FirestoreCollectionNames.usersCollection)
        .doc(userModel.uid)
        .set(userModel.toMap());
  }
}
