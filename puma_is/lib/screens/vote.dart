import 'package:flutter/material.dart';
import 'package:puma_is/models/vote_model.dart';
import 'package:puma_is/services/vote_services.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  String selectedCandidate = '';
  bool isVotingCompleted = false;
  bool hasVoted = false; // Track if user has voted
  final VoteService _voteService = VoteService();

  // Automatically generate candidate details
  final List<Map<String, String>> candidates = [
    {
      'name': 'Candidate 1',
      'chairperson': 'Liam Davis',
      'viceChairperson': 'Bob Johnson',
      'image': 'assets/images/candidates-1.jpg',
    },
    {
      'name': 'Candidate 2',
      'chairperson': 'Jack Manuel',
      'viceChairperson': 'Alice Smith',
      'image': 'assets/images/candidates-2.jpg',
    },
  ];

  // Function to handle voting
  void handleVote(String candidateId) async {
    setState(() {
      selectedCandidate = candidateId;
    });

    String email = _voteService.getUserEmail();

    // Check if the user has already voted
    bool hasVotedBefore = await _voteService.hasUserVoted(email);

    if (hasVotedBefore) {
      // If the email has already voted, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'You have already voted!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show a confirmation dialog before submitting the vote
    bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Vote'),
          content: Text('Are you sure you want to vote for ${candidates[int.parse(candidateId) - 1]['name']}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel vote
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm vote
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // If confirmed, save the vote to Firestore
      Vote vote = Vote(
        candidate: candidates[int.parse(candidateId) - 1]['name']!, // Use candidate name
        email: email,
        timestamp: DateTime.now(),
      );
      await _voteService.saveVote(vote);

      setState(() {
        isVotingCompleted = true;
        hasVoted = true; // User has voted
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thank you for your vote, ${candidates[int.parse(candidateId) - 1]['name']}',
            style: const TextStyle(color: Colors.white), // White text for contrast
          ),
          backgroundColor: Colors.green, // Green background color
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Vote for Chairperson & Vice Chairperson',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display the candidates dynamically
            ...candidates.asMap().entries.map((entry) {
              String candidateId = (entry.key + 1).toString(); // Automatically generate candidate ID
              var candidate = entry.value;
              return Column(
                children: [
                  Image.asset(
                    candidate['image']!,
                    height: 200,
                    width: 200,
                  ),
                  RadioListTile<String>(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(candidate['name']!),
                        Text(
                          '${candidate['chairperson']}\n${candidate['viceChairperson']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    value: candidateId,
                    groupValue: selectedCandidate,
                    onChanged: (String? value) {
                      if (value != null && !hasVoted) {
                        handleVote(value); // Show confirmation and save vote if confirmed
                      }
                    },
                  ),
                ],
              );
            }).toList(),
            // Display the vote result message if the user has voted
            if (hasVoted)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.green, // Green background
                    child: Text(
                      'You voted for: ${candidates[int.parse(selectedCandidate) - 1]['name']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text color
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Chairperson: ${candidates[int.parse(selectedCandidate) - 1]['chairperson']}\nVice Chairperson: ${candidates[int.parse(selectedCandidate) - 1]['viceChairperson']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
