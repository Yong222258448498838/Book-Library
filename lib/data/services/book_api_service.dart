import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:final_mobile/data/model/book_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

class BookApiService {
  // Fetch all books
  Future<List<BookModel>> fetchBooks() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.books}');

    try {
      debugPrint('GET $url');
      final response = await http.get(url);
      debugPrint('Status code: ${response.statusCode}');
      debugPrint(
        'Response preview: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final books = data.map((json) => BookModel.fromJson(json)).toList();

        debugPrint('Fetched ${books.length} books');
        for (final book in books.take(5)) {
          debugPrint('${book.id} | ${book.title} | ${book.author}');
        }

        return books;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network connection failed: $e');
    }
  }

  // Search books via query parameter
  Future<List<BookModel>> searchBooks(String query) async {
    // MockAPI filters by appending query parameters like ?title=name
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.books}?title=$query',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookModel.fromJson(json)).toList();
      } else {
        throw Exception('Search error');
      }
    } catch (e) {
      throw Exception('Network error during search: $e');
    }
  }
}
