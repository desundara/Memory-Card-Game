class HighScoreModel {
  final int? id;
  final String playerName;
  final String difficulty;
  final int moves;
  final int timeSeconds;
  final String date;

  HighScoreModel({
    this.id,
    required this.playerName,
    required this.difficulty,
    required this.moves,
    required this.timeSeconds,
    required this.date,
  });

  // Convert HighScoreModel -> Map (for inserting into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player_name': playerName,
      'difficulty': difficulty,
      'moves': moves,
      'time_seconds': timeSeconds,
      'date': date,
    };
  }

  // Convert Map (from SQLite) -> HighScoreModel
  factory HighScoreModel.fromMap(Map<String, dynamic> map) {
    return HighScoreModel(
      id: map['id'],
      playerName: map['player_name'],
      difficulty: map['difficulty'],
      moves: map['moves'],
      timeSeconds: map['time_seconds'],
      date: map['date'],
    );
  }
}