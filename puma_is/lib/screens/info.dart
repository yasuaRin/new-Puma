import 'package:flutter/material.dart';
import 'package:puma_is/controllers/InfoController.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final InfoController _controller = InfoController();
  List<Map<String, dynamic>> _infoList = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData(); // Fetch all data when the page is initialized
  }

  // Fetch all data
  void _fetchAllData() async {
    List<Map<String, dynamic>> data = await _controller.fetchAllInfo();
    setState(() {
      _infoList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information Page"),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the info list or a message if no data
            Expanded(
              child: _infoList.isEmpty
                  ? const Center(
                      child: Text(
                        "No events available.",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _infoList.length,
                      itemBuilder: (context, index) {
                        final info = _infoList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              info['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Content: ${info['content']}"),
                                Text("Contact: ${info['contactPerson']}"),
                                Text("Date: ${DateTime.parse(info['dateTime'].toDate().toString()).toLocal()}"),
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