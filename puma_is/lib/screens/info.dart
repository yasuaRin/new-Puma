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
    // Check if dark mode is enabled
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Information Page"),
        backgroundColor: isDarkMode ? Colors.grey[850] : Color(0xffB3C8CF), // Set grey color for dark mode
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Set the background depending on the theme mode
          gradient: isDarkMode
              ? null
              : LinearGradient(
                  colors: [Colors.blueGrey, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isDarkMode ? Colors.grey[850] : Colors.transparent, // Set grey for dark mode
        ),
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
                          color: isDarkMode ? Colors.grey[800] : Colors.white, // Adjust card color based on theme
                          child: ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.info_outline, // Info icon
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 8), // Space between the icon and text
                                Text(
                                  info['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Content: ${info['content']}",
                                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                                ),
                                Text(
                                  "Contact: ${info['contactPerson']}",
                                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                                ),
                                Text(
                                  "Date: ${DateTime.parse(info['dateTime'].toDate().toString()).toLocal()}",
                                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
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
