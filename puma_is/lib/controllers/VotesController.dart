import 'package:flutter/material.dart';
import 'package:puma_is/services/vote_services.dart';
import 'package:puma_is/models/vote_model.dart';

class VotingController with ChangeNotifier {
  final VoteService _voteService = VoteService();
  Map<String, int> _voteCounts = {};

  Map<String, int> get voteCounts => _voteCounts;

  // Fetch vote counts
  Future<void> fetchVoteCounts() async {
    try {
      _voteCounts = await _voteService.getVoteCounts();
      notifyListeners();
    } catch (e) {
      print("Error fetching vote counts: $e");
    }
  }
}
