import 'package:flutter/material.dart';
import 'package:puma_is/screens/vote.dart';
import 'package:puma_is/screens/info.dart';
import 'package:puma_is/screens/signin.dart';
import 'package:puma_is/screens/event.dart';

class homePage extends StatefulWidget {
  final String loggedInEmail;

  const homePage({Key? key, required this.loggedInEmail}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String selectedFeature = 'dashboard'; // Tracks the current selected feature
  String get loggedInEmail => widget.loggedInEmail;

  // Method to get username from the email (part before '@')
  String get username {
    return loggedInEmail.split('@')[0];
  }

  // Widget that returns different pages based on the selected feature
  Widget buildBody() {
    switch (selectedFeature) {
      case 'vote':
        return const VotePage(); // Use the VotePage from vote.dart
      case 'info': // Show InfoPage when selectedFeature is 'info'
        return InfoPage();
      case 'events': // Show EventsPage when selectedFeature is 'events'
           return EventPage();
      default:
        return const Center(child: Text('Welcome to homepage'));
    }
  }

  // Function to display event filter options
  void showEventFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Events'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Upcoming Events'),
                onTap: () {
                  // Handle filter for upcoming events
                  print("Filter: Upcoming");
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ListTile(
                title: const Text('Past Events'),
                onTap: () {
                  // Handle filter for past events
                  print("Filter: Past");
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(username), // Display the extracted username
              accountEmail: Text(loggedInEmail), // Display email
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text('L'), // Initials or image
              ),
            ),
            ListTile(
              title: const Text('Vote for Chairperson'),
              leading: const Icon(Icons.how_to_vote),
              onTap: () {
                setState(() {
                  selectedFeature = 'vote'; // Set selected feature to 'vote'
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Information Session'),
              leading: const Icon(Icons.info),
              onTap: () {
                setState(() {
                  selectedFeature = 'info'; // Set selected feature to 'info'
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Event'),
              leading: const Icon(Icons.event),
              onTap: () {
                setState(() {
                  selectedFeature =
                      'events'; // Set selected feature to 'events'
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              leading: const Icon(Icons.logout),
              onTap: () {
                // Navigate to SignIn page upon sign-out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const SignIn(), // Replace with your SignIn page
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: buildBody(),
    );
  }
}

class EventsPage extends StatelessWidget {
  final VoidCallback onFilterPressed;

  const EventsPage({Key? key, required this.onFilterPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Add a filter button that triggers the filter dialog
        ElevatedButton(
          onPressed: onFilterPressed, // Call the filter function when pressed
          child: const Text('Filter Events'),
        ),
        // Display events here (You can replace this with actual events fetching logic)
        const Expanded(
          child: Center(child: Text('Event List will be shown here.')),
        ),
      ],
    );
  }
}
