import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puma_is/services/auth_service.dart';
import 'package:puma_is/screens/home.dart'; // Import the homePage widget

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String fullName = '';
  String ID = '';
  bool termsCondition = false;

  final _authService = AuthService();

  Future<void> onPressedSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (password != confirmPassword) {
        const snackBar = SnackBar(content: Text('Passwords do not match.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (!termsCondition) {
        const snackBar =
            SnackBar(content: Text('You must accept the terms and conditions.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      try {
        // Call AuthService to handle signup
        await _authService.signup(
          id: ID,
          email: email,
          fullName: fullName,
          password: password,
          confirmPassword: confirmPassword,
          termsCondition: termsCondition,
          context: context,
        );

        // Show success message
        const snackBar = SnackBar(
          content: Text('Successfully Registered!'),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigate to the home page after successful signup
         Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => homePage(loggedInEmail: email)),
        );
      } catch (error) {
        // Handle errors (e.g., email already in use)
        final snackBar = SnackBar(
          content: Text('Registration failed: ${error.toString()}'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Full Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                onChanged: (value) => fullName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              // Email Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              // ID Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID'),
                onChanged: (value) => ID = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID';
                  }
                  return null;
                },
              ),
              // Password Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              // Confirm Password Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onChanged: (value) => confirmPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              // Terms and Conditions Checkbox
              Row(
                children: [
                  Checkbox(
                    value: termsCondition,
                    onChanged: (value) => setState(() => termsCondition= value!),
                  ),
                  const Text('I accept the terms and conditions'),
                ],
              ),
              // Sign Up Button
              ElevatedButton(
                onPressed: onPressedSignUp,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
