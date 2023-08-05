import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:eds_beta/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userAPIProvider = Provider<UserAPI>((ref) {
  final databaseAPI = ref.watch(databaseAPIProvider);
  final authController = ref.watch(authControllerProvider.notifier);
  return UserAPI(databaseAPI: databaseAPI, authController: authController);
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userAPI = ref.watch(userAPIProvider);
  final uid = ref.watch(authChangesProvider).value?.uid;
  if (uid == null) {
    return null;
  }
  final currentUser = await userAPI.getUserData(uid: uid);
  return currentUser;
});

abstract class IUserAPI {
  Future<UserModel?> getUserData({required String uid});
  Future<UserModel?> createUser({required User user});
}

class UserAPI implements IUserAPI {
  final DatabaseAPI _databaseAPI;

  final AuthController _authController;
  UserAPI(
      {required DatabaseAPI databaseAPI,
      required AuthController authController})
      : _databaseAPI = databaseAPI,
        _authController = authController;

  @override
  Future<UserModel?> getUserData({required String uid}) async {
    try {
      return await _databaseAPI.getUserDataFromDB(uid: uid);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> createUser({required user}) async {
    final user = await _authController.currentUser();
    if (user != null) {
      UserModel userModel = UserModel.fromFirebaseUser(user: user);
      await _databaseAPI.createUserDoc(userModel: userModel);
    }
    return null;
  }
}
