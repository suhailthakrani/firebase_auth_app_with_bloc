import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final box = GetStorage();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationID = '';
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      if (userCredential.user != null) {
        User user = userCredential.user!;

        log(stackTrace: StackTrace.fromString("Anonymous User"), "$user");
        return user;
      }

      // User is signed in anonymously
    } on FirebaseAuthException catch (e) {
      // Handle sign-in errors
      print('FirebaseAuthException on signin anonymously: $e');
    } catch (e) {
      // Handle sign-in errors
      print('Failed to sign in anonymously: $e');
    }
    return null;
  }

  Future<User?> signUpWithEmail(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User user = userCredential.user!;
        user.updateDisplayName(name);
        box.write("email", email);
        box.write("password", password);
        box.write("name", name);
        log(stackTrace: StackTrace.fromString("Signed Up User"), "$user");

        return user;
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign-in errors
      print('FirebaseAuthException on sign up with email: $e');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User user = userCredential.user!;

        log(
            stackTrace: StackTrace.fromString("Signed Up User--------->"),
            "$user");

        return user;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException on sign in with email: $e');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      signOutFromGoogle();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException on sign in with email: $e');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> continueWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(authCredential);
        User? user = userCredential.user;
        log(stackTrace: StackTrace.fromString("Signed Up User"), "$user");

        return user;
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign-in errors
      print('FirebaseAuthException on sign up with email: $e');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signOutFromGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signOut();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(authCredential);
        User? user = userCredential.user;
        log(stackTrace: StackTrace.fromString("Signed Up User"), "$user");

        return user;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException on sign up with email: $e');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future sendOtpOnPhone({required String phone}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          print("----------------- $phoneAuthCredential");
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: phoneAuthCredential.verificationId!, smsCode: phoneAuthCredential.smsCode!);
          // await auth.signInWithCredential(phoneAuthCredential);
          print(credential);
        },
        verificationFailed: (FirebaseAuthException error) {
          print('Verification Failed: ${error.message}');
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          _verificationID = verificationId;
          print("verificationId = $verificationId forceResendingToken :  $forceResendingToken");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code Auto-Retrieval Timeout: $verificationId');
        },
        timeout: const Duration(seconds: 120));
        
  }

  Future verifyOtp({required String smsCode}) async {
    print("------------ ${smsCode}");
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
        verificationId: _verificationID,
        smsCode: smsCode,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(phoneAuthCredential);

      final User? user = userCredential.user;
      if (user != null) {
        print('OTP Verification Successful. User ID: ${user.uid}');
        return null;
      } else {
        print('OTP Verification Failed');
        return false;
      }
    } catch (error) {
      print('OTP Verification Failed : $error');
      return error;
    }
  }
}
