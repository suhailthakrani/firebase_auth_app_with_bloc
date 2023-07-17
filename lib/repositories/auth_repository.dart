import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final box = GetStorage();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
    }
    catch (e) {
      // Handle sign-in errors
      print('Failed to sign in anonymously: $e');
      
    }
    return null;
  }

  Future<User?> signUpWithEmail(
      {required String email, required String password, required String name}) async {
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

  Future<User?> signInWithEmail({required String email, required String password}) async {
     try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.credential != null) {
        User? user = userCredential.user;

      log(stackTrace: StackTrace.fromString("Signed Up User"), "$user");

      return user;
      }
    } on FirebaseAuthException catch (e) {
      // Handle sign-in errors
      print('FirebaseAuthException on sign in with email: $e');
    } catch (e) {
      print(e);
      
    }
    return null;
  }
  Future<User?> continueWithGoogle() async {
    
     try {
      
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(authCredential);
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
  Future continueWithPhone() async {}
}
