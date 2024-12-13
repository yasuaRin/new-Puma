import 'package:flutter/material.dart';
import 'package:puma_is/controllers/MemberController.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final MemberController _controller = MemberController();
  List<Map<String, dynamic>> _memberList = [];

  // Map of member names to their respective image paths
  final Map<String, String> memberImages = {
    'John Doe': 'assets/images/johndoe.jpg',
    'Jane Smith': 'assets/images/jane_smith.jpg',
    'Alex Johnson': 'assets/images/alex_johnson.jpg',
  };

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  // Fetch all data
  void _fetchAllData() async {
    List<Map<String, dynamic>> data = await _controller.fetchAllMembers();
    setState(() {
      _memberList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Page"),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Member List",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _memberList.isEmpty
                  ? const Center(
                      child: Text(
                        "No members available.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _memberList.length,
                      itemBuilder: (context, index) {
                        final member = _memberList[index];
                        final memberName = member['fullName'] ?? 'Unknown Member';
                        final memberBatch = member['batch'] ?? 'Unknown Batch';
                        final memberPosition = member['position'] ?? 'Unknown Position';
                        final imageUrl = memberImages[memberName] ?? 'assets/images/default.jpg';

                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        memberName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Batch: $memberBatch",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Position: $memberPosition",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
