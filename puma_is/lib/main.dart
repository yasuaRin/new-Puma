import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puma_is/screens/Signup.dart';
import 'package:puma_is/screens/home.dart'; // Import the home page
import 'package:puma_is/screens/SignIn.dart'; // Import the sign-in page
import 'package:puma_is/splash_screen.dart'; // Import the splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PUMA IS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Light theme
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark, // Dark theme
      ),
      themeMode: ThemeMode.system, // Follow the system theme (light or dark)
      home: const SplashScreen(), // Set SplashScreen as the initial screen
      routes: {
        '/signup': (context) => Signup(),
        '/signin': (context) => SignIn(),
        '/home': (context) => homePage(loggedInEmail: ''), // Adjust as needed
      },
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the user is already signed in
    User? user = FirebaseAuth.instance.currentUser;

    // If user is logged in, navigate to home screen, else sign-in screen
    if (user != null) {
      return homePage(loggedInEmail: user.email!); // Pass logged-in user's email
    } else {
      return SignIn(); // Show sign-in screen if not logged in
    }
  }
}
