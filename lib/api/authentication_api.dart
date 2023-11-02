import 'dart:async';
import 'dart:developer';
import 'package:eds_beta/core/core.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authAPIProvider = Provider<AuthAPI>((ref) {
  final auth = FirebaseAuth.instance;
  return AuthAPI(auth: auth);
});

final authChangesProvider = StreamProvider<User?>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  return authAPI.authChanges();
});

final isNewUserProvider = FutureProvider((ref)async {
  final user =  ref.watch(currentAuthUserProvider).value;
  return await ref.watch(databaseAPIProvider).isNewUser(uid: user!.uid);
});

final currentAuthUserProvider = FutureProvider<User?>((ref) async {
  final authAPI = ref.watch(authAPIProvider);
  final res = await authAPI.getCurrentUser();
  return res.fold((l) => null, (r) => r);
});

abstract class IAuthAPI {
  Future<bool> sendOTP({required String phoneNumber});
  Future<bool> reSendOTP({required String phoneNumber});
  FutureEither<User> sigInWithOTP({required String smsCode});
  FutureEither<User> signInWithGoogle();
  FutureEither<User> register(
      {required String email, required String password});
  FutureVoid logout();
  FutureEither<User> getCurrentUser();
  Stream<User?> authChanges();
}

class AuthAPI implements IAuthAPI {
  final FirebaseAuth _auth;
  String verificationCodeFromFirebase = '';
  int? forceResendingToken;
  static bool isLoggedIn = false;

  AuthAPI({required FirebaseAuth auth}) : _auth = auth;

  @override
  Future<bool> sendOTP({required String phoneNumber, int? resendToken}) async {
    log("Sending OTP");
    bool didSend = false;
    Completer<bool> completer = Completer<bool>();

    try {
      await _auth.verifyPhoneNumber(
        forceResendingToken: resendToken,
        verificationCompleted: (phoneAuthCredential) {
          didSend = true;
          if (!completer.isCompleted) {
            // Check if completer is already completed
            completer.complete(didSend);
          }
        },
        verificationFailed: (e) {
          log(e.message.toString());
          didSend = false;
          if (!completer.isCompleted) {
            completer.complete(didSend);
          }
        },
        codeSent: (verificationId, resendingToken) {
          verificationCodeFromFirebase = verificationId;
          forceResendingToken = resendingToken!;
          didSend = true;
          log("Code sent");
          if (!completer.isCompleted) {
            completer.complete(didSend);
          }
        },
        codeAutoRetrievalTimeout: (String code) {
          verificationCodeFromFirebase = code;
          didSend = true;
          if (!completer.isCompleted) {
            completer.complete(didSend);
          }
        },
        phoneNumber: phoneNumber,
      );

      return await completer.future;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> reSendOTP({required String phoneNumber}) async {
    log("Resending otp");
    return await sendOTP(
        phoneNumber: phoneNumber, resendToken: forceResendingToken);
  }

  @override
  FutureEither<User> sigInWithOTP({required String smsCode}) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationCodeFromFirebase, smsCode: smsCode);
      final res = await _auth.signInWithCredential(credential);

      return right(res.user as User);
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  FutureEither<User> getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        return right(user);
      } else {
        return left(Failure(
            message: 'No user is currently signed in',
            stackTrace: StackTrace.current));
      }
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  FutureEither<User> register(
      {required String email, required String password}) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      isLoggedIn = true;
      return right(result.user as User);
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  FutureVoid logout() async {
    await _auth.signOut();
    isLoggedIn = false;
  }

  @override
  FutureEither<User> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      return right(await _auth.signInWithCredential(credentials).then((value) {
        isLoggedIn = true;
        return value.user as User;
      }));
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Stream<User?> authChanges() {
    return _auth.authStateChanges();
  }
}
