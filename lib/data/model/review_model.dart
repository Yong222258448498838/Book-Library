class ReviewModel {
  final String itemId;
  final String text;
  final int rating;
  final DateTime createdAt;

  const ReviewModel({
    required this.itemId,
    required this.text,
    required this.rating,
    required this.createdAt,
  });
}
