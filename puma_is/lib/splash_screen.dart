import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:puma_is/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puma_is/screens/Signin.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SplashContent(),
      nextScreen: AuthChecker(), // Use AuthChecker to decide the next screen
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white, // Customize background color
      duration: 7000, // Extended duration to 7 seconds
    );
  }
}

class SplashContent extends StatefulWidget {
  @override
  _SplashContentState createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  bool showLogo = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () {
      // Delay before showing the logo
      setState(() {
        showLogo = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Image with zoom-in effect
        if (showLogo)
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 3.0), // Increased zoom effect for more scale
            duration: const Duration(milliseconds: 3000), // Animation duration
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Image.asset(
                  'assets/images/PUMA_IS_BG.jpg', // Ensure this file exists
                  width: 900, // Fixed size of 900 pixels for width
                  height: 900, // Fixed size of 900 pixels for height
                  fit: BoxFit.contain, // Ensure image fits well
                ),
              );
            },
          ),
      ],
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
