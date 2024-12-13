// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:final_project/reusable_widgets/reusable_widget.dart';
// import 'package:final_project/screens/Student_Dashboard.dart';
// import 'package:final_project/utils/color.dart';
import 'package:flutter/material.dart';
class Student_Dashboard extends StatefulWidget {
  const Student_Dashboard({super.key});
  @override
  State<StatefulWidget> createState() {
    return _StudentDashboardState(); // Return the state class here
  }
}
class _StudentDashboardState extends State<Student_Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.black, // Assuming primaryColor is defined in color.dart
      ),
      body: const Center(
        child: Text(
          'Student Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}