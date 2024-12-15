import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:puma_is/screens/admin/Admin_Dashboard.dart';
import 'package:puma_is/screens/home.dart'; // Home Page
import 'Signup.dart'; // Signup Page

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  String email = '';
  String password = '';
  bool _isPasswordVisible = false;

  // Callback to capture the email input
  void onChangedUsername(String value) {
    setState(() {
      email = value;
    });
  }

  // Callback to capture the password input
  void onChangedPassword(String value) {
    setState(() {
      password = value;
    });
  }

  // Validate Email format
  bool _validateEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email);
  }

  // Validate Password (minimum length check)
  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  // Sign In button action
  Future<void> onPressedSignIn() async {
    if (email == 'admin@gmail.com' && password == 'Admin123') {
      // Admin Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Admin_Dashboard()),
      );
    } else {
      // Firebase authentication for regular users
      if (!_validateEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email address')),
        );
        return;
      }

      if (!_validatePassword(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password should be at least 6 characters')),
        );
        return;
      }

      try {
        // Firebase sign-in
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        // If the login is successful, navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homePage(loggedInEmail: email)),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // User not found error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No account found. Please create an account.')),
          );
        } else if (e.code == 'wrong-password') {
          // Wrong password error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password. Please try again.')),
          );
        } else {
          // Other Firebase authentication errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error signing in: ${e.message}')),
          );
        }
      }
    }
  }

  // Navigate to Sign Up screen
  void onPressedSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffB3C8CF), Color(0xffFFE3E3)],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22, right: 22),
            child: Column(
              children: [
                Center(
                  child: Image(
                    image: AssetImage('assets/images/logonew.png'),
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Stay Connected and Stay Informed!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      // Email input field
                      TextField(
                        onChanged: onChangedUsername,
                        style: const TextStyle(color: Colors.black), // Text color when typing
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          labelText: 'Gmail',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB3C8CF),

                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                            color: Color(0xffB3C8CF),

                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password input field
                      TextField(
                        obscureText: !_isPasswordVisible,
                        onChanged: onChangedPassword,
                        style: const TextStyle(color: Colors.black), // Text color when typing
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                           color: Color(0xffB3C8CF),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color(0xffB3C8CF),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 30),
                      // Sign In button
                      GestureDetector(
                        onTap: onPressedSignIn,
                        child: Container(
                          height: 45,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xffB3C8CF), Color(0xffFFE3E3)],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Sign up section
                      Column(
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: onPressedSignUp,
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
