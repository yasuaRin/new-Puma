import 'package:flutter/material.dart';
import 'package:puma_is/controllers/InfoController.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final InfoController _controller = InfoController();
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _infoList = [];

  // Fetch data for the selected date
  void _fetchData() async {
    if (_selectedDate != null) {
      List<Map<String, dynamic>> data = await _controller.fetchInfoForDate(_selectedDate!);
      setState(() {
        _infoList = data;
      });

      // Show dialog if no data is found
      if (_infoList.isEmpty) {
        _showNoEventsDialog();
      }
    }
  }

  // Dialog to show when no events are found
  void _showNoEventsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Upcoming Events"),
          content: Text("There are no events for the selected date."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
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
        title: Text("Information Page"),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (_selectedDate != null) {
                    _fetchData(); // Fetch data after date is selected
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                   foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Pick Date",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Display the info list or a message if no data
            Expanded(
              child: _infoList.isEmpty
                  ? Center(
                      child: Text(
                        "No events available for the selected date.",
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
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
