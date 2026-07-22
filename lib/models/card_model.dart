class CardModel {
  final int id;
  final String imagePath; // or icon/emoji identifier
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.id,
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });
}