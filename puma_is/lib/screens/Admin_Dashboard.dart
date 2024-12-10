import 'package:flutter/material.dart';
import 'package:puma_is/screens/admin/manage_info.dart';
import 'package:puma_is/screens/vote.dart';
import 'package:puma_is/screens/info.dart';
import 'package:puma_is/screens/signin.dart';
import 'package:puma_is/screens/admin/manage_voting.dart'; // Import the ManageVoting page
import 'package:puma_is/screens/admin/manage_users.dart';
import 'package:puma_is/screens/admin/manage_event.dart';

class Admin_Dashboard extends StatefulWidget {
  const Admin_Dashboard({Key? key}) : super(key: key);

  @override
  State<Admin_Dashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<Admin_Dashboard> {
  String selectedFeature = 'dashboard'; // Tracks the current selected feature

  // Widget that returns different pages based on the selected feature
  Widget buildBody() {
    switch (selectedFeature) {
      case 'vote':
        return const VotePage(); // Display the Vote Page
      case 'info':
        return ManageInfoPage(); // Display the Info Page
      case 'manage_voting':
        return ManageVotingPage(); // Display the Manage Voting page
      case 'manage_users':
        return ManageUsersPage();
      case 'manage_event':
        return ManageEventPage();
      default:
        return const Center(
          child: Text(
            'Welcome to Admin Dashboard!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  void showAccessDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access Denied'),
          content:
              const Text('You do not have permission to access this feature.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void handleRestrictedFeature() {
    // Example restricted feature logic
    showAccessDeniedDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Admin'),
              accountEmail: Text(''), // Removed email display
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text('A'), // Display a placeholder letter or an image
              ),
            ),
            ListTile(
              title: const Text('Manage Users'),
              leading: const Icon(Icons.person),
              onTap: () {
                // Update selected feature state to 'manage_users'
                setState(() {
                  selectedFeature = 'manage_users';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Manage Voting'),
              leading: const Icon(Icons.how_to_vote),
              onTap: () {
                // Update selected feature state to 'manage_voting'
                setState(() {
                  selectedFeature = 'manage_voting';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Manage Information'),
              leading: const Icon(Icons.info),
              onTap: () {
                setState(() {
                  selectedFeature = 'info';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Manage Event'),
              leading: const Icon(Icons.info),
              onTap: () {
                setState(() {
                  selectedFeature = 'manage_event';
                });
                Navigator.pop(context);
              },
            ),
            
            // Sign Out button moved outside of the ExpansionTile
            ListTile(
              title: const Text('Sign Out'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                // Navigate to the Sign-In page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
            ),
          ],
        ),
      ),
      body: buildBody(), // Show the appropriate page based on selectedFeature
    );
  }
}
