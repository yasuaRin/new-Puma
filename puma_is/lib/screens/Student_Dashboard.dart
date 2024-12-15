import 'package:flutter/material.dart';
class Student_Dashboard extends StatefulWidget {
  const Student_Dashboard({super.key});
  @override
  State<StatefulWidget> createState() {
    return _StudentDashboardState(); 
  }
}
class _StudentDashboardState extends State<Student_Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.black, 
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