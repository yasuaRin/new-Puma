import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Signin.dart'; // Import the SignIn page

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String emailOrPhone = '';
  String password = '';
  String confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SignUp function
  Future<void> onSignUpPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create the user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailOrPhone,
          password: password,
        );
        // If sign-up is successful, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        // You can also navigate to another screen (e.g., Home screen)
      } on FirebaseAuthException catch (e) {
        // Handle error messages from Firebase
        String message = e.message ?? 'An error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffB3C8CF), Color(0xffFFE3E3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
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
                width: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        // Full Name Input Field
                        TextFormField(
                          style: const TextStyle(color: Colors.black), // Text color when typing
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            labelText: 'Full Name',
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
                          onChanged: (value) => fullName = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your full name' : null,
                        ),
                        const SizedBox(height: 20),
                        // Email Input Field
                        TextFormField(
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
                          onChanged: (value) => emailOrPhone = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your Gmail' : null,
                        ),
                        const SizedBox(height: 20),
                        // Password Input Field
                        TextFormField(
                          obscureText: !_isPasswordVisible,
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
                          onChanged: (value) => password = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your password' : null,
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password Input Field
                        TextFormField(
                          obscureText: !_isConfirmPasswordVisible,
                          style: const TextStyle(color: Colors.black), // Text color when typing
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            labelText: 'Confirm Password',
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
                          onChanged: (value) => confirmPassword = value,
                          validator: (value) =>
                              value != password ? 'Passwords do not match' : null,
                        ),
                        const SizedBox(height: 30),
                        // SignUp Button
                        GestureDetector(
                          onTap: onSignUpPressed,
                          child: Container(
                            height: 45,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xffB3C8CF), Color(0xffFFE3E3)],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Sign-In Navigation Text
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignIn(),
                              ),
                            );
                          },
                          child: const Center(
                            child: Column(
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
