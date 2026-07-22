import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/high_score_model.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({super.key});

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<HighScoreModel> _scores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await _dbHelper.getScores();
    setState(() {
      _scores = scores;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _scores.isEmpty
              ? const Center(
                  child: Text(
                    'No high scores yet.\nPlay a game to set a record!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _scores.length,
                  itemBuilder: (context, index) {
                    final score = _scores[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(score.playerName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${score.difficulty} • ${score.moves} moves • ${score.timeSeconds}s • ${score.date}'),
                      ),
                    );
                  },
                ),
    );
  }
}