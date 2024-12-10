import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puma_is/models/vote_model.dart';

class VoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get the current user's email
  String getUserEmail() {
    return "user@example.com"; // Replace with the actual user email
  }

  // Check if the user has voted before based on their email
  Future<bool> hasUserVoted(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('votes')
          .where('email', isEqualTo: email)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if user has voted: $e");
      return false;
    }
  }

  // Save the user's vote to Firestore with automatic ID generation
  Future<void> saveVote(Vote vote) async {
    try {
      // Get the last document to calculate the next incremented document ID
      QuerySnapshot snapshot = await _firestore.collection('votes').orderBy('timestamp', descending: true).limit(1).get();
      
      int nextVoteId = 1; // Default vote ID
      if (snapshot.docs.isNotEmpty) {
        // Increment the last vote ID based on the latest timestamp
        var lastVote = snapshot.docs.first;
        nextVoteId = lastVote.id == null ? 1 : int.parse(lastVote.id) + 1;
      }

      // Save the vote with the next incremented vote ID
      await _firestore.collection('votes').doc(nextVoteId.toString()).set({
        'candidate': vote.candidate,  // String (e.g., "candidate1" or "candidate2")
        'email': vote.email,          // String
        'timestamp': vote.timestamp,  // Timestamp
      });
    } catch (e) {
      print("Error saving vote: $e");
    }
  }

  // Fetch a user's votes
  Future<List<Vote>> getUserVotes(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('votes')
          .where('email', isEqualTo: email)
          .get();

      return snapshot.docs.map((doc) {
        return Vote(
          candidate: doc['candidate'],                      // String
          email: doc['email'],                              // String
          timestamp: (doc['timestamp'] as Timestamp).toDate(),  // DateTime
        );
      }).toList();
    } catch (e) {
      print("Error fetching user votes: $e");
      return [];
    }
  }

  // Fetch all votes from Firestore as a list
  Future<List<Vote>> getAllVotes() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('votes').get();

      return snapshot.docs.map((doc) {
        return Vote(
          candidate: doc['candidate'],                      // String
          email: doc['email'],                              // String
          timestamp: (doc['timestamp'] as Timestamp).toDate(),  // DateTime
        );
      }).toList();
    } catch (e) {
      print("Error fetching all votes: $e");
      return [];
    }
  }

  // Fetch the vote count for each candidate
  Future<Map<String, int>> getVoteCounts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('votes').get();

      Map<String, int> voteCounts = {};
      for (var doc in snapshot.docs) {
        String candidate = doc['candidate'];  // String (e.g., "candidate1")
        voteCounts[candidate] = (voteCounts[candidate] ?? 0) + 1;
      }
      return voteCounts;
    } catch (e) {
      print("Error fetching vote counts: $e");
      return {};
    }
  }

  // Fetch all votes as a stream
  Stream<List<Vote>> getVotes() {
    try {
      return _firestore.collection('votes').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Vote(
            candidate: doc['candidate'],                     // String
            email: doc['email'],                             // String
            timestamp: (doc['timestamp'] as Timestamp).toDate(),  // DateTime
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching votes: $e");
      return Stream.empty();
    }
  }

  // Delete a vote by its document ID
  Future<void> deleteVote(String voteId) async {
    try {
      await _firestore.collection('votes').doc(voteId).delete();
    } catch (e) {
      print("Error deleting vote: $e");
    }
  }

  // Update a vote
  Future<void> updateVote(String voteId, String newCandidate) async {
    try {
      await _firestore.collection('votes').doc(voteId).update({
        'candidate': newCandidate,  // Update the candidate field
      });
    } catch (e) {
      print("Error updating vote: $e");
    }
  }
}
