import 'package:flutter/material.dart';
import 'game_screen.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Difficulty'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _difficultyCard(context, 'Easy', '4 x 4 Grid (8 Pairs)', 4, 4),
            const SizedBox(height: 20),
            _difficultyCard(context, 'Medium', '4 x 5 Grid (10 Pairs)', 4, 5),
            const SizedBox(height: 20),
            _difficultyCard(context, 'Hard', '4 x 6 Grid (12 Pairs)', 4, 6),
          ],
        ),
      ),
    );
  }

  Widget _difficultyCard(BuildContext context, String title, String subtitle,
      int rows, int cols) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title,
            style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                difficulty: title,
                rows: rows,
                cols: cols,
              ),
            ),
          );
        },
      ),
    );
  }
}