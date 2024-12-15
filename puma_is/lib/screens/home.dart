import 'package:flutter/material.dart';
import 'package:puma_is/screens/member.dart';
import 'package:puma_is/screens/info.dart';
import 'package:puma_is/screens/signin.dart';
import 'package:puma_is/screens/event.dart';

class homePage extends StatefulWidget {
  final String loggedInEmail;

  const homePage({super.key, required this.loggedInEmail});

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

  // Data for Q&A
  final List<Map<String, String>> questions = [
    {'question': 'How can I join?', 'answer': 'You can join by registering on our website or contacting us directly.'},
    {'question': 'What events do you organize?', 'answer': 'We organize tech workshops, hackathons, and networking events.'},
    {'question': 'When can I join the Puma registration?', 'answer': 'Wait for the next event or stay tuned in this application in the information section.'},
    {'question': 'Do I need prior experience to join?', 'answer': 'No prior experience is required. We welcome all students interested in IS development.'},
    {'question': 'Is there a membership fee?', 'answer': 'No, joining Puma IS is free for all students.'},
    {'question': 'What skills can I gain by joining Puma IS?', 'answer': 'You can gain technical, organizational, and networking skills through workshops and events.'},
    {'question': 'Can I participate in Puma events as a non-member?', 'answer': 'Yes, most of our events are open to everyone, even if you are not a member.'},
  ];

  // Widget that returns different pages based on the selected feature
  Widget buildBody() {
    switch (selectedFeature) {
      // case 'vote':
      //   return const VotePage(); // Use the VotePage from vote.dart
      case 'info':
        return InfoPage(); // Show InfoPage when selectedFeature is 'info'
      case 'events':
        return EventPage();
      case 'member':
        return MemberPage();
      default:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
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
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Latest Information Section (without button)
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'About PUMA IS',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Puma IS (President University Major Association Information System) is a student organization at President University that focuses on Information Systems (IS) development and related activities. The organization serves as a platform for students to enhance their skills in areas such as technology, management, and system development. Puma IS organizes various events, including workshops, hackathons, networking sessions, and other tech-related activities to help students build their knowledge and prepare for careers in the information systems field. It is also a community where students can collaborate, learn, and engage with industry professionals.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Our PUMA IS Members Section
                  const SizedBox(height: 30),
                  // Q&A Section
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Centered title for FAQ
                        const Center(
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
                              title: Text(
                                questionData['question']!,
                                style: const TextStyle(
                                  color: Colors.black, // Change question color to black
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    questionData['answer']!,
                                    style: const TextStyle(
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    loggedInEmail,
                    style: const TextStyle(color: Colors.white),
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
              leading: const Icon(Icons.how_to_vote),
              title: const Text('Member'),
              onTap: () {
                setState(() {
                  selectedFeature = 'member';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Information'),
              onTap: () {
                setState(() {
                  selectedFeature = 'info';
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
            // Logout Button
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
