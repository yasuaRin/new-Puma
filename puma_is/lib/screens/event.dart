// import 'package:flutter/material.dart';
// import 'package:puma_is/models/event_model.dart'; // Import EventModel

// class EventPage extends StatefulWidget {
//   const EventPage({Key? key}) : super(key: key);

//   @override
//   _EventPageState createState() => _EventPageState();
// }

// class _EventPageState extends State<EventPage> {
//   late List<EventModel> events; // Add a list to store events
//   late List<EventModel> filteredEvents;

//   @override
//   void initState() {
//     super.initState();
//     // Placeholder for actual event fetching. Replace with API call or database query.
//     events = [
//       EventModel(
//         name: "Tech Conference 2024",
//         date: DateTime(2024, 5, 15),
//         description: "Join us for the annual tech conference.",
//         location: "San Francisco, CA", eventID: '',
//       ),
//       EventModel(
//         name: "AI Workshop",
//         date: DateTime(2023, 12, 10),
//         description: "Learn about AI and its applications.",
//         location: "New York, NY",
//       ),
//       // Add more events here...
//     ];
//     filteredEvents = events;
//   }

//   // Function to show filter dialog and apply selected filter
//   void showEventFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Filter Events'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: const Text('Upcoming Events'),
//                 onTap: () {
//                   setState(() {
//                     filteredEvents = events
//                         .where((event) => event.date.isAfter(DateTime.now()))
//                         .toList();
//                   });
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//               ),
//               ListTile(
//                 title: const Text('Past Events'),
//                 onTap: () {
//                   setState(() {
//                     filteredEvents = events
//                         .where((event) => event.date.isBefore(DateTime.now()))
//                         .toList();
//                   });
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Events'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: showEventFilterDialog, // Show filter dialog when clicked
//           ),
//         ],
//       ),
//       body: filteredEvents.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: filteredEvents.length,
//               itemBuilder: (context, index) {
//                 final event = filteredEvents[index];
//                 return EventCard(event: event);
//               },
//             ),
//     );
//   }
// }

// class EventCard extends StatelessWidget {
//   final EventModel event;

//   const EventCard({Key? key, required this.event}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               event.name,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               'Date: ${event.date}',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               event.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Location: ${event.location}',
//               style: const TextStyle(fontSize: 16, color: Colors.blue),
//             ),
//             const SizedBox(height: 15),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Event: ${event.name} selected')),
//                 );
//               },
//               child: const Text('View Event'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
