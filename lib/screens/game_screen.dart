import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../database/db_helper.dart';
import '../models/high_score_model.dart';

class GameScreen extends StatefulWidget {
  final String difficulty;
  final int rows;
  final int cols;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.rows,
    required this.cols,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> _emojis = [
    '🍎', '🍌', '🍇', '🍉', '🍓', '🍒', '🍍', '🥝',
    '🥑', '🍑', '🍋', '🥭'
  ];

  late List<CardModel> _cards;
  List<int> _flippedIndexes = [];
  int _moves = 0;
  int _matchedPairs = 0;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
  }

  void _initializeGame() {
    int totalPairs = (widget.rows * widget.cols) ~/ 2;
    List<String> selectedEmojis = _emojis.sublist(0, totalPairs);
    List<String> cardEmojis = [...selectedEmojis, ...selectedEmojis];
    cardEmojis.shuffle(Random());

    _cards = List.generate(
      cardEmojis.length,
      (index) => CardModel(id: index, imagePath: cardEmojis[index]),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _onCardTap(int index) {
    // IF card already flipped or matched -> ignore (Selection)
    if (_busy || _cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
      _flippedIndexes.add(index);
    });

    // IF 2 cards flipped -> check match (Selection)
    if (_flippedIndexes.length == 2) {
      _busy = true;
      _moves++;
      _checkMatch();
    }
  }

  void _checkMatch() {
    int first = _flippedIndexes[0];
    int second = _flippedIndexes[1];

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        if (_cards[first].imagePath == _cards[second].imagePath) {
          // Match found
          _cards[first].isMatched = true;
          _cards[second].isMatched = true;
          _matchedPairs++;
        } else {
          // No match - flip back
          _cards[first].isFlipped = false;
          _cards[second].isFlipped = false;
        }
        _flippedIndexes.clear();
        _busy = false;
      });

      // IF all matched -> end game loop (Selection)
      if (_matchedPairs == _cards.length ~/ 2) {
        _timer?.cancel();
        _showWinDialog();
      }
    });
  }

  void _showWinDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 You Won!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Moves: $_moves\nTime: $_secondsElapsed seconds'),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String name = nameController.text.trim().isEmpty
                  ? 'Player'
                  : nameController.text.trim();

              final score = HighScoreModel(
                playerName: name,
                difficulty: widget.difficulty,
                moves: _moves,
                timeSeconds: _secondsElapsed,
                date: DateTime.now().toString().split(' ')[0],
              );

              await DBHelper().insertScore(score);

              if (context.mounted) {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // back to difficulty screen
              }
            },
            child: const Text('Save & Back to Menu'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty} Mode'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Moves: $_moves',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Time: $_secondsElapsed s',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: _cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.cols,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: card.isMatched
                            ? Colors.green.shade200
                            : card.isFlipped
                                ? Colors.white
                                : Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: (card.isFlipped || card.isMatched)
                            ? Text(card.imagePath,
                                style: const TextStyle(fontSize: 28))
                            : const Icon(Icons.help_outline,
                                color: Colors.white, size: 28),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}