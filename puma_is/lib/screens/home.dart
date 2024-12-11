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

  // Data for members
  final List<Map<String, String>> leadership = [
    {'name': 'Alice Johnson', 'role': 'Chairperson', 'image': 'assets/leader1.png'},
    {'name': 'Bob Smith', 'role': 'Vice Chairperson', 'image': 'assets/leader2.png'},
  ];

  final List<Map<String, String>> secretary = [
    {'name': 'Catherine Lee', 'role': 'Secretary', 'image': 'assets/secretary.png'},
  ];

  final List<Map<String, String>> treasurer = [
    {'name': 'David Brown', 'role': 'Treasurer', 'image': 'assets/treasurer.png'},
  ];

  final List<Map<String, String>> marketing = [
    {'name': 'Eve White', 'role': 'Marketing', 'image': 'assets/marketing.png'},
  ];

  final List<Map<String, String>> development = [
    {'name': 'Frank Green', 'role': 'Development', 'image': 'assets/development.png'},
  ];

  final List<Map<String, String>> design = [
    {'name': 'Grace Black', 'role': 'Design', 'image': 'assets/design.png'},
  ];

  // Data for Q&A
  final List<Map<String, String>> questions = [
    {'question': 'What is Puma IS?', 'answer': 'Puma IS is a student organization focusing on IS development.'},
    {'question': 'How can I join?', 'answer': 'You can join by registering on our website or contacting us directly.'},
    {'question': 'What events do you organize?', 'answer': 'We organize tech workshops, hackathons, and networking events.'},
  ];

  // Widget that returns different pages based on the selected feature
  Widget buildBody() {
    switch (selectedFeature) {
      case 'vote':
        return const VotePage(); // Use the VotePage from vote.dart
      case 'info':
        return InfoPage(); // Show InfoPage when selectedFeature is 'info'
      case 'events':
        return EventPage(); // Show EventsPage when selectedFeature is 'events'
      default:
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffB3C8CF), Color(0xffFFE3E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Welcome section with gradient background
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.home,
                          size: 100,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome to the Homepage',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Hello, $username!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Latest Information Section
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Latest Information',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Stay updated with the latest news and updates. Check out upcoming events, vote for chairperson, and attend info sessions!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedFeature = 'events'; // Navigate to the events page
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                          ),
                          child: const Text(
                            'See Events',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Our PUMA IS Members Section
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Centered title for PUMA IS Members
                        Center(
                          child: Text(
                            'PUMA IS Members 2024',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Leadership section
                        Text(
                          'Leadership',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: leadership.map((member) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(member['image']!),
                              ),
                              title: Text(member['name']!),
                              subtitle: Text(member['role']!),
                            );
                          }).toList(),
                        ),
                        const Divider(),
                        // Secretary section
                        Text(
                          'Secretary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: secretary.map((member) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(member['image']!),
                              ),
                              title: Text(member['name']!),
                              subtitle: Text(member['role']!),
                            );
                          }).toList(),
                        ),
                        const Divider(),
                        // Other sections follow the same pattern...
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Q&A Section
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Centered title for FAQ
                        Center(
                          child: Text(
                            'FAQ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: questions.map((questionData) {
                            final index = questions.indexOf(questionData);
                            return ExpansionTile(
                              title: Text(questionData['question']!),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    questionData['answer']!,
                                    style: TextStyle(
                                      color: Colors.black, // Set the answer text color
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
          ),
        ],
      ),
      body: buildBody(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_image.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hello, $username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    loggedInEmail,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  selectedFeature = 'dashboard';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
              onTap: () {
                setState(() {
                  selectedFeature = 'events';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQ'),
              onTap: () {
                setState(() {
                  selectedFeature = 'info';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
