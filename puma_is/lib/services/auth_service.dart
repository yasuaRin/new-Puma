import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:puma_is/screens/home.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get full name from Firestore based on the email
  Future<String?> getFullNameByEmail(String email) async {
    try {
      // Query Firestore for the user's full name using email
      final querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the full name if found
        return querySnapshot.docs.first['fullName'];
      } else {
        print("No user found for the email: $email");
        return null; // No user found
      }
    } catch (e) {
      print("Error fetching full name: $e");
      return null; // Handle error and return null
    }
  }

  // Method to handle sign up process
  Future<void> signup({
    required String id,
    required String confirmPassword,
    required String email,
    required String fullName,
    required String password,
    required bool termsCondition,
    required BuildContext context,
  }) async {
    try {
      // Create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      // Save additional data to Firestore
      await _firestore.collection('user').doc(userCredential.user!.uid).set({
        'ID': id,
        'fullName': fullName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'termsCondition': termsCondition,
        'createdAt':
            FieldValue.serverTimestamp(), // Save timestamp for registration
      });

      // Get the logged-in user's email
      String? loggedInEmail = FirebaseAuth.instance.currentUser?.email;

      // Check if the email is successfully fetched
      if (loggedInEmail != null) {
        // Navigate to the homepage with the logged-in email
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                homePage(loggedInEmail: loggedInEmail),
          ),
        );
      } else {
        // If no email is found, show a toast error message
        Fluttertoast.showToast(
          msg: 'Error: Could not fetch logged-in email.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // Method to handle login process
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in the user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get the logged-in user's email
      String? loggedInEmail = userCredential.user?.email;

      if (loggedInEmail != null) {
        // Check if the user's data exists in Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('user')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // If user data exists in Firestore, navigate to the homepage
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  homePage(loggedInEmail: loggedInEmail),
            ),
          );
        } else {
          // If no user data exists in Firestore, show an error
          Fluttertoast.showToast(
            msg: 'User data not found. Please sign up first.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          // Log out the user since no data is found
          await FirebaseAuth.instance.signOut();
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Error: Could not fetch logged-in email.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // Method to handle logout
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
        msg: 'Logged out successfully.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: Could not log out.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
