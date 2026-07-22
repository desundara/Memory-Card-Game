import 'package:flutter/material.dart';
import 'difficulty_screen.dart';
import 'high_score_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.grid_view_rounded,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 10),
              const Text(
                'Memory Match',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 50),
              _menuButton(context, 'Start Game', Icons.play_arrow, () {
                // TODO: Navigate to Difficulty Select screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifficultyScreen(),
                  ),
                );
              }),
              const SizedBox(height: 15),
              _menuButton(context, 'High Scores', Icons.leaderboard, () {
                // TODO: Navigate to High Score screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HighScoreScreen()),
                );
              }),
              const SizedBox(height: 15),
              _menuButton(context, 'About', Icons.info_outline, () {
                // TODO: Navigate to About screen
              }),
              const SizedBox(height: 15),
              _menuButton(context, 'Help', Icons.help_outline, () {
                // TODO: Navigate to Help screen
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
