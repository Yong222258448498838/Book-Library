import 'dart:convert';
import 'package:final_mobile/data/model/book_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

class BookApiService {
  // Fetch all books
  Future<List<BookModel>> fetchBooks() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.book}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookModel.fromJson(json)).toList();
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
      '${ApiConstants.baseUrl}${ApiConstants.book}?title=$query',
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
