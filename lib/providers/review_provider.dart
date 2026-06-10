import 'package:final_mobile/data/model/review_model.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  final List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  List<ReviewModel> reviewsForItem(String itemId) {
    return _reviews.where((review) => review.itemId == itemId).toList();
  }

  void addReview({
    required String itemId,
    required String text,
    required int rating,
  }) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    _reviews.add(
      ReviewModel(
        itemId: itemId,
        text: cleanText,
        rating: rating,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
