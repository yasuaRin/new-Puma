import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:puma_is/screens/admin/Admin_Dashboard.dart';
import 'package:puma_is/screens/home.dart'; 
import 'Signup.dart'; 

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  String email = '';
  String password = '';
  bool _isPasswordVisible = false;

  void onChangedUsername(String value) {
    setState(() {
      email = value;
    });
  }

  void onChangedPassword(String value) {
    setState(() {
      password = value;
    });
  }

  bool _validateEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  Future<void> onPressedSignIn() async {
    if (email == 'admin@gmail.com' && password == 'Admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Admin_Dashboard()),
      );
    } else {
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
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homePage(loggedInEmail: email)),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No account found. Please create an account.')),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password. Please try again.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error signing in: ${e.message}')),
          );
        }
      }
    }
  }

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
                      TextField(
                        onChanged: onChangedUsername,
                        style: const TextStyle(color: Colors.black), 
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
                      TextField(
                        obscureText: !_isPasswordVisible,
                        onChanged: onChangedPassword,
                        style: const TextStyle(color: Colors.black), 
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
