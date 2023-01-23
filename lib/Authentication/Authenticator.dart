import 'package:budgetbuddy/Authentication/widgets/snackbar.dart';
import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate {
  static bool firstLaunch = false;
  final String name = '';
  final String email = '';
  final String password = '';
  final String location = '';
  late final BuildContext context;

  Future login(context, email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      CustomSnackBar(context, const Text('Logged in successfully! Loading...'),
          backgroundColor: Colors.green);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomSnackBar(context, const Text('User not found!'),
            backgroundColor: Colors.red);
      } else if (e.code == 'wrong-password') {
        CustomSnackBar(context, const Text('Incorrect Password!'),
            backgroundColor: Colors.red);
      }
    } catch (e) {
      CustomSnackBar(context, const Text('An unknown error occured.'),
          backgroundColor: Colors.red);
    }
  }

  Future signUp({context, email, password, name, location}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      CustomSnackBar(context, const Text('Initializing Database...'),
          backgroundColor: Colors.orange);
      return InitDatabase(
          name: name,
          email: email,
          user: user,
          location: location,
          credential: userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomSnackBar(
            context, const Text('The password provided is too weak.'),
            backgroundColor: Colors.red);
      } else if (e.code == 'email-already-in-use') {
        CustomSnackBar(
            context, const Text('An account already exists for this email.'),
            backgroundColor: Colors.red);
      }
    } catch (e) {
      CustomSnackBar(context, const Text('An unknown error occured.'),
          backgroundColor: Colors.red);
    }
  }
}
