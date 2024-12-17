import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<DocumentSnapshot> _filteredMembers = [];
  List<DocumentSnapshot> _allMembers = [];
  String _currentFilter = 'All';
  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _itemsLimit = 13;

  final Map<String, String> memberImages = {
    'John Doe': 'assets/images/johndoe.jpg',
    'Alex Johnson': 'assets/images/alexjohnson.jpg',
    'Jane Smith': 'assets/images/janesmith.jpg',
    'Jack Wanson': 'assets/images/jackwanson.jpg',
    'Jessica Lout': 'assets/images/jessicalout.jpg',
    'Bob Racky': 'assets/images/bobracky.jpg',
    'Sasky Rachellyn': 'assets/images/saskyrachellyn.jpg',
    'George Simanjuntak': 'assets/images/georgesimanjuntak.jpg',
    'Roger Zhu': 'assets/images/rogerzhu.jpg',
    'Callysta Kenny': 'assets/images/callystakenny.jpg',
    'Jeremyah Ferguson': 'assets/images/jeremyahferguson.jpg',
    'Lily Blossom': 'assets/images/lilyblossom.jpeg',
    'Jacky Witeen': 'assets/images/jackywiteen.jpeg',
  };

  @override
  void initState() {
    super.initState();
    _fetchMembersByDivision(_currentFilter);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchMembersByDivision(String division) async {
    try {
      var memberQuery = FirebaseFirestore.instance.collection('Members');
      var memberSnapshot = await memberQuery.get();

      List<DocumentSnapshot> allMembers = memberSnapshot.docs;
      List<DocumentSnapshot> filteredMembers = allMembers.where((doc) {
        var memberData = doc.data() as Map<String, dynamic>;
        return division == 'All' || memberData['division'] == division;
      }).toList();

      setState(() {
        _allMembers = allMembers;
        _filteredMembers = filteredMembers.take(_itemsLimit).toList();
      });
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  void _updateMemberFilter(String division) {
    setState(() => _currentFilter = division);
    _fetchMembersByDivision(division);

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      _loadMoreMembers();
    }
  }

  void _loadMoreMembers() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoadingMore = false;
        _itemsLimit += 10;
        _filteredMembers = _allMembers.take(_itemsLimit).toList();
      });
    });
  }

  String _convertToString(dynamic value) {
    if (value == null) return 'No Data';
    return value.toString();
  }

  Widget _buildMemberCard(
      String fullName, String batch, String position, String division, String imagePath) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                fullName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Batch: $batch\nPosition: $position\nDivision: $division',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _updateMemberFilter,
            itemBuilder: (BuildContext context) {
              return {
                'All',
                'BoD',
                'Public Relation',
                'Art and Sport',
                'Student Development'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              }).toList();
            },
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          double childAspectRatio = 1.0;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      _currentFilter == 'All'
                          ? 'All Members'
                          : 'Members in $_currentFilter Division',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _filteredMembers.isEmpty
                    ? const Center(
                        child: Text(
                          'No Members Found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: _filteredMembers.length,
                        itemBuilder: (context, index) {
                          var memberDoc = _filteredMembers[index];
                          var member = memberDoc.data() as Map<String, dynamic>;
                          String fullName = member['fullName'] ?? 'No Name';
                          String batch = _convertToString(member['batch']);
                          String position = _convertToString(member['position']);
                          String division = member['division'] ?? 'No Division';
                          String imagePath = memberImages[fullName] ??
                              'assets/images/default.jpg';

                          return _buildMemberCard(
                              fullName, batch, position, division, imagePath);
                        },
                      ),
                if (_isLoadingMore)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
