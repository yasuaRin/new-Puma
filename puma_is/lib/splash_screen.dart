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
      nextScreen: AuthChecker(), 
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white, 
      duration: 7000, 
    );
  }
}

class SplashContent extends StatefulWidget {
  const SplashContent({super.key});

  @override
  _SplashContentState createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  bool showLogo = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () {
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
        if (showLogo)
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 3.0), 
            duration: const Duration(milliseconds: 3000), 
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Image.asset(
                  'assets/images/PUMA_IS_BG.jpg', 
                  width: 900, 
                  height: 900, 
                  fit: BoxFit.contain, 
                ),
              );
            },
          ),
      ],
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return homePage(loggedInEmail: user.email!); 
    } else {
      return const SignIn(); 
    }
  }
}
