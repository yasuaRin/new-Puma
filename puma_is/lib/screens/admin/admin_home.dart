import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puma_is/screens/admin/manage_member.dart';
import 'package:puma_is/screens/admin/manage_info.dart';
import 'package:puma_is/screens/admin/manage_users.dart';
import 'package:puma_is/screens/admin/manage_event.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        centerTitle: true,
        backgroundColor: const Color(0xffB3C8CF),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( // Changed from Center to Column for better vertical alignment control
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
              Expanded( // Use Expanded to make the GridView take available space without expanding indefinitely
                child: GridView.count(
                  crossAxisCount: 2, // 2 cards in each row
                  crossAxisSpacing: 16.0, // Space between columns
                  mainAxisSpacing: 16.0, // Space between rows
                  shrinkWrap: true, // Ensures GridView takes only as much space as it needs
                  children: [
                    _buildCard(
                      title: 'Total Events',
                      stream: FirebaseFirestore.instance
                          .collection('events')
                          .snapshots()
                          .map((snapshot) => snapshot.docs.length),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ManageEventPage()),
                        );
                      },
                    ),
                    _buildCard(
                      title: 'Registered Users',
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .snapshots()
                          .map((snapshot) => snapshot.docs.length),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ManageUsersPage()),
                        );
                      },
                    ),
                    _buildCard(
                      title: 'Total Information',
                      stream: FirebaseFirestore.instance
                          .collection('info')
                          .snapshots()
                          .map((snapshot) => snapshot.docs.length),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ManageInfoPage()),
                        );
                      },
                    ),
                    _buildCard(
                      title: 'Total Member',
                      stream: FirebaseFirestore.instance
                          .collection('Members')
                          .snapshots()
                          .map((snapshot) => snapshot.docs.length),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageMemberPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Stream<int> stream,
    required VoidCallback onTap,
  }) {
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        } else if (snapshot.hasError) {
          return _buildErrorCard();
        } else if (!snapshot.hasData) {
          return _buildNoDataCard();
        }

        return GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            shadowColor: const Color(0xffB3C8CF).withOpacity(0.5),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffB3C8CF), Color(0xffFFE3E3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: const Color(0xffB3C8CF).withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xffB3C8CF),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: const Color(0xffB3C8CF).withOpacity(0.5),
      child: const Center(
        child: Text(
          'Error fetching data',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: const Color(0xffB3C8CF).withOpacity(0.5),
      child: const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
