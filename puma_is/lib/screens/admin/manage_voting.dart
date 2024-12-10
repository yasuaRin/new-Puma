import 'package:flutter/material.dart';
import 'package:puma_is/models/vote_model.dart';
import 'package:puma_is/services/vote_services.dart';

class ManageVotingPage extends StatefulWidget {
  const ManageVotingPage({Key? key}) : super(key: key);

  @override
  State<ManageVotingPage> createState() => _ManageVotingPageState();
}

class _ManageVotingPageState extends State<ManageVotingPage> {
  final VoteService _voteService = VoteService();
  List<Vote> votes = [];
  bool isLoading = true;

  // Define candidates with id, name, and additional information
  final List<Map<String, String>> candidates = [
    {
      'id': '1',
      'name': 'Candidate 1',
      'chairperson': 'Liam Davis',
      'viceChairperson': 'Bob Johnson',
    },
    {
      'id': '2',
      'name': 'Candidate 2',
      'chairperson': 'Jack Manuel',
      'viceChairperson': 'Alice Smith',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchVotes();
  }

  // Fetch votes from the backend (Firestore)
  Future<void> fetchVotes() async {
    try {
      votes = await _voteService.getAllVotes();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching votes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Voting'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Voting Results',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Display voting results for each candidate
                  ...candidates.map((candidate) {
                    String candidateId = candidate['id']!;
                    List<Vote> candidateVotes = votes
                        .where((vote) => vote.candidate == candidateId)
                        .toList();
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(candidate['name']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Chairperson: ${candidate['chairperson']}'),
                            Text(
                                'Vice Chairperson: ${candidate['viceChairperson']}'),
                            const SizedBox(height: 8),
                          
                          ],
                        ),
                        trailing: Text(
                          '${candidateId.length} Votess',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  // Display total votes
                  const SizedBox(height: 20),
                  Text(
                    'Total Votes: ${votes.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
