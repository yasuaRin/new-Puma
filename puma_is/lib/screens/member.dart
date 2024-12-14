import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<DocumentSnapshot> _filteredMembers = [];
  List<DocumentSnapshot> _allMembers = [];
  String _currentFilter = 'All';
  ScrollController _scrollController = ScrollController(); // Add ScrollController

  // Map of event names to image paths
  final Map<String, String> memberImages = {
    'John Doe': 'assets/images/johndoe.jpg',
    'Alex Johnson': 'assets/images/alexjohnson.jpg',
    'Jane Smith': 'assets/images/janesmith.jpg',
    'Jack Wanson': 'assets/images/jackwanson.jpg',
    'Jessica Lout': 'assets/images/jessicalout.jpg',
    'Bob Racky': 'assets/images/bobracky.jpg',
    'Sasky Rachellyn': 'assets/images/saskyrachellyn.jpg',
    'George Simanjuntak': 'assets/images/georgesimanjuntak.jpg',
    'Roger Zhu': 'assets/images/rogerzhu.jpg',
    'Callysta Kenny': 'assets/images/callystakenny.jpg',
    'Jeremyah Ferguson': 'assets/images/jeremyahferguson.jpg',
    'George Simanjuntak': 'assets/images/georgesimanjuntak.jpg',
    'Lily Blossom': 'assets/images/lilyblossom.jpeg',
    'Jacky Witeen': 'assets/images/jackywiteen.jpeg',
  };

  void _fetchMembersByDivision(String division) async {
    var memberQuery = FirebaseFirestore.instance.collection('Members');

    try {
      var member = await memberQuery.get();
      print("Fetched ${member.docs.length} members");

      List<DocumentSnapshot> filteredMembers = [];
      List<DocumentSnapshot> allMembers = [];

      for (var doc in member.docs) {
        var memberData = doc.data() as Map<String, dynamic>;
        allMembers.add(doc); // Add to all members list

        // Apply filter based on division
        if (_currentFilter == 'All' || memberData['division'] == _currentFilter) {
          filteredMembers.add(doc);
        }
      }

      setState(() {
        _filteredMembers = filteredMembers;
        _allMembers = allMembers;
      });
    } catch (e) {
      print("Error fetching members: $e");
    }
  }

  // Update the filter to apply the division filter and scroll to top
  void _updateMemberFilter(String division) {
    setState(() {
      _currentFilter = division;
    });
    _fetchMembersByDivision(division);

    // Scroll to the top after filter update with a small delay to allow UI rebuild
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMembersByDivision(_currentFilter); // Initial fetch for 'All'
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members Page'),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: _updateMemberFilter,
            itemBuilder: (BuildContext context) {
              return {'All', 'BoD', 'Public Relation', 'Art and Sport', 'Student Development'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap everything in SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(  // Center the text
                child: Text(
                  _currentFilter == 'All'
                      ? 'All Members'
                      : 'Members in $_currentFilter Division',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Wrap the ListView in a Scrollbar
            Scrollbar(
              child: ListView(
                controller: _scrollController, // Attach the controller here
                shrinkWrap: true, // Allow ListView to use minimal space
                children: [
                  _buildMemberList(_filteredMembers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build member list
  Widget _buildMemberList(List<DocumentSnapshot> memberList) {
    if (memberList.isEmpty) {
      return const Center(child: Text('No members available.'));
    }

    return Column(
      children: memberList.map((memberDoc) {
        var member = memberDoc.data() as Map<String, dynamic>;
        var fullName = member['fullName'] ?? 'No Name';
        var batch = member['batch'] ?? 'No Batch';
        var position = member['position'] ?? 'No Position';
        var division = member['division'] ?? 'No Division';

        String imagePath = memberImages[fullName] ?? 'assets/images/default.jpg';

        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image display
                Image.asset(
                  imagePath,
                  width: 80, // Adjust width as needed
                  height: 80, // Adjust height as needed
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Batch: $batch',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Position: $position',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Division: $division',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
