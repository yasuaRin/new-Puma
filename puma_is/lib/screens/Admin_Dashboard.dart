import 'package:flutter/material.dart';
import 'package:puma_is/screens/admin/manage_info.dart';
import 'package:puma_is/screens/vote.dart';
import 'package:puma_is/screens/info.dart';
import 'package:puma_is/screens/signin.dart';
import 'package:puma_is/screens/admin/manage_voting.dart'; // Import the ManageVoting page
import 'package:puma_is/screens/admin/manage_users.dart';
import 'package:puma_is/screens/admin/manage_event.dart';
import 'package:puma_is/screens/event.dart'; // Import the EventPage

class Admin_Dashboard extends StatefulWidget {
  const Admin_Dashboard({Key? key}) : super(key: key);

  @override
  State<Admin_Dashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<Admin_Dashboard> {
  String selectedFeature = 'dashboard'; // Tracks the current selected feature
  String selectedEventFeature =
      'manage_event'; // Tracks the selected event feature
  String selectedVotingFeature =
      'manage_voting'; // Tracks the selected voting feature
  String selectedInfoFeature =
      'manage_info'; // Tracks the selected information feature

  // Widget that returns different pages based on the selected feature
  Widget buildBody() {
    switch (selectedFeature) {
      case 'vote':
        return const VotePage(); // Display the Vote Page
      case 'info':
        return InfoPage(); // Display the Info Page
      case 'manage_info':
        return ManageInfoPage();
      case 'manage_voting':
        return ManageVotingPage(); // Display the Manage Voting page
      case 'manage_users':
        return ManageUsersPage(); // Display the Manage Users page
      case 'manage_event':
        return ManageEventPage(); // Display the Manage Event page
      case 'event_page':
        return EventPage(); // Display the Event Page
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
                setState(() {
                  selectedFeature = 'manage_users';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Dropdown for Manage Voting using ExpansionTile
            ExpansionTile(
              title: const Text('Vote'),
              leading: const Icon(Icons.event),
              children: <Widget>[
                ListTile(
                  title: const Text('Manage Vote'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'manage_voting';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('Voting Page'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'vote';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
            // Dropdown for Manage Information using ExpansionTile
            ExpansionTile(
              title: const Text('Information'),
              leading: const Icon(Icons.event),
              children: <Widget>[
                ListTile(
                  title: const Text('Manage Info'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'manage_info';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('Info Page'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'info';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
            // Dropdown for Event using ExpansionTile
            ExpansionTile(
              title: const Text('Event'),
              leading: const Icon(Icons.event),
              children: <Widget>[
                ListTile(
                  title: const Text('Manage Event'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'manage_event';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('Event Page'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'event_page';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
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
