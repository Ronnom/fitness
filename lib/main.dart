import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(FitnessChallengeApp());
}

class FitnessChallengeApp extends StatelessWidget {
  const FitnessChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Challenge',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[850],
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[500],
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AboutUsScreen(),
    CreateChallengeScreen(),
    ProgressScreen(),
    LeaderboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Challenge')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[900]),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Create Challenge'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Track Progress'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Leaderboard'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'AboutUs'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Progress'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        ],
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Fitness Challenge App',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 10),
            Text(
                'The Fitness Challenge app is designed to help users stay motivated and achieve their fitness goals through friendly challenges. Whether you are looking to compete with friends or track your personal progress, this app makes it easy and fun.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            SizedBox(height: 20),
            Text('Developed by Ronald Damo & John Philip Baloro',
                style: TextStyle(fontSize: 18, color: Colors.white70)),
            SizedBox(height: 10),
            Text('Key Features:',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            Text('- Create and track fitness challenges',
                style: TextStyle(color: Colors.white70)),
            Text('- View progress and compete on the leaderboard',
                style: TextStyle(color: Colors.white70)),
            Text('- Easy to use with a simple and intuitive design',
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final TextEditingController _challengeNameController =
      TextEditingController();
  final TextEditingController _challengeGoalController =
      TextEditingController();
  final TextEditingController _challengeUnitController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _challenges = [];

  Future<void> _saveChallenge() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _challenges.add({
        'name': _challengeNameController.text,
        'goal': int.tryParse(_challengeGoalController.text) ?? 0,
        'unit': _challengeUnitController.text,
        'progress': 0,
      });
      await prefs.setString('challenges', jsonEncode(_challenges));
      _challengeNameController.clear();
      _challengeGoalController.clear();
      _challengeUnitController.clear();
      setState(() {});
    }
  }

  Future<void> _loadChallenges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedChallenges = prefs.getString('challenges');
    if (storedChallenges != null) {
      setState(() {
        _challenges =
            List<Map<String, dynamic>>.from(jsonDecode(storedChallenges));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _challengeNameController,
                  decoration: const InputDecoration(
                      labelText: 'Challenge Name',
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a challenge name' : null,
                ),
                TextFormField(
                  controller: _challengeGoalController,
                  decoration: const InputDecoration(
                      labelText: 'Challenge Goal',
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a goal' : null,
                ),
                TextFormField(
                  controller: _challengeUnitController,
                  decoration: const InputDecoration(
                      labelText: 'Challenge Unit (e.g., km, reps)',
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a unit' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChallenge,
                  child: const Text('Save Challenge'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Map<String, dynamic>> _challenges = [];

  Future<void> _loadChallenges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedChallenges = prefs.getString('challenges');
    if (storedChallenges != null) {
      setState(() {
        _challenges =
            List<Map<String, dynamic>>.from(jsonDecode(storedChallenges));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _challenges.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_challenges[index]['name']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goal: ${_challenges[index]['goal']}'),
              LinearProgressIndicator(
                value: (_challenges[index]['progress'] ?? 0) / 100,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              setState(() {
                _challenges[index]['progress'] =
                    (_challenges[index]['progress'] ?? 0) + 10;
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('challenges', jsonEncode(_challenges));
            },
          ),
        );
      },
    );
  }
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'Ronald', 'score': 120},
    {'name': 'Lenard', 'score': 100},
    {'name': 'Bjorn', 'score': 80},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _leaderboard.length,
      itemBuilder: (context, index) {
        final entry = _leaderboard[index];
        return Card(
          color: Colors.grey[800],
          child: ListTile(
            title: Text(entry['name'], style: TextStyle(color: Colors.white)),
            trailing: Text('${entry['score']} pts',
                style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}
