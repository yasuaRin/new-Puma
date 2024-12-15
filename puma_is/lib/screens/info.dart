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
    _fetchAllData();
  }

  void _fetchAllData() async {
    List<Map<String, dynamic>> data = await _controller.fetchAllInfo();
    setState(() {
      _infoList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Information Page"),
        backgroundColor: isDarkMode ? Colors.grey[850] : Color(0xffB3C8CF), 
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? null
              : LinearGradient(
                  colors: [Colors.blueGrey, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isDarkMode ? Colors.grey[850] : Colors.transparent,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          color: isDarkMode ? Colors.grey[800] : Colors.white,
                          child: ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.info_outline, 
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 8), 
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
