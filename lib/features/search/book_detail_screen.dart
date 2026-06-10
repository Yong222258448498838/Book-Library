import 'package:final_mobile/data/model/book_model.dart';
import 'package:final_mobile/features/chat/chat_screen.dart';
import 'package:final_mobile/features/review/write_review_screen.dart';
import 'package:final_mobile/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 240,
              child: book.cover.isEmpty
                  ? const Center(child: Icon(Icons.menu_book, size: 80))
                  : Image.network(
                      book.cover,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.menu_book, size: 80),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<BookProvider>(
                  builder: (context, provider, child) {
                    final isSaved = provider.isBookSaved(book);

                    return IconButton.filledTonal(
                      tooltip: isSaved ? 'Remove saved book' : 'Save book',
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () => provider.toggleSavedBook(book),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Author: ${book.author}'),
            Text('Price: \$${book.price}'),
            const SizedBox(height: 16),
            Text(book.decription),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(book: book),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.rate_review),
                    label: const Text('Review'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WriteReviewScreen(book: book),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
