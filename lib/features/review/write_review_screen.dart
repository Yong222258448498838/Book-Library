import 'package:final_mobile/data/model/book_model.dart';
import 'package:final_mobile/providers/review_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WriteReviewScreen extends StatefulWidget {
  final BookModel book;

  const WriteReviewScreen({super.key, required this.book});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _saveReview() {
    context.read<ReviewProvider>().addReview(
      itemId: widget.book.id,
      text: _reviewController.text,
      rating: _rating,
    );

    _reviewController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review saved locally')));
  }

  @override
  Widget build(BuildContext context) {
    final savedReviews = context.watch<ReviewProvider>().reviewsForItem(
      widget.book.id,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Review ${widget.book.title}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Rating', style: Theme.of(context).textTheme.titleMedium),
          DropdownButton<int>(
            value: _rating,
            items: const [
              DropdownMenuItem(value: 1, child: Text('1 star')),
              DropdownMenuItem(value: 2, child: Text('2 stars')),
              DropdownMenuItem(value: 3, child: Text('3 stars')),
              DropdownMenuItem(value: 4, child: Text('4 stars')),
              DropdownMenuItem(value: 5, child: Text('5 stars')),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _rating = value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reviewController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write your review',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saveReview,
            child: const Text('Save Review'),
          ),
          const SizedBox(height: 24),
          Text('Local Reviews', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (savedReviews.isEmpty)
            const Text('No local reviews yet.')
          else
            for (final review in savedReviews)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${review.rating} stars'),
                subtitle: Text(review.text),
              ),
        ],
      ),
    );
  }
}
