import 'package:flutter/material.dart';
import 'package:puma_is/screens/admin/admin_home.dart';
import 'package:puma_is/screens/member.dart';
import 'package:puma_is/screens/signin.dart';
import 'package:puma_is/screens/info.dart';
import 'package:puma_is/screens/admin/manage_info.dart';
import 'package:puma_is/screens/admin/manage_member.dart';
import 'package:puma_is/screens/admin/manage_users.dart';
import 'package:puma_is/screens/admin/manage_event.dart';
import 'package:puma_is/screens/event.dart';

class Admin_Dashboard extends StatefulWidget {
  const Admin_Dashboard({super.key});

  @override
  State<Admin_Dashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<Admin_Dashboard> {
  String selectedFeature = 'dashboard'; // Default feature

  // Method to dynamically load pages based on the selected feature
  Widget buildBody() {
    switch (selectedFeature) {
      // case 'vote':
      //   return const VotePage();
      case 'info':
        return InfoPage();
      case 'manage_info':
        return ManageInfoPage();
      case 'manage_users':
        return ManageUsersPage();
      case 'manage_event':
        return ManageEventPage();
      case 'event_page':
        return EventPage();
      case 'manage_member':
        return ManageMemberPage();
        case 'member':
        return MemberPage();
      default:
        return const AdminHome(); // Render AdminHome by default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Admin'),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text('A'),
              ),
            ),
            ListTile(
              title: const Text('Dashboard'),
              leading: const Icon(Icons.dashboard),
              onTap: () {
                setState(() {
                  selectedFeature = 'dashboard';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.event),
              title: const Text('Event'),
              children: [
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
            ExpansionTile(
              leading: const Icon(Icons.info),
              title: const Text('Info'),
              children: [
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
            ExpansionTile(
              leading: const Icon(Icons.people),
              title: const Text('Member'),
              children: [
                ListTile(
                  title: const Text('Manage Member'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'manage_member';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: const Text('Member Page'),
                  onTap: () {
                    setState(() {
                      selectedFeature = 'member';
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text('Sign Out'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
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
