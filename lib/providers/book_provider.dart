import 'package:final_mobile/data/model/book_model.dart';
import 'package:final_mobile/data/services/book_api_service.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  final BookApiService _apiService = BookApiService();

  List<BookModel> _books = [];
  List<BookModel> _searchResults = [];
  final List<BookModel> _savedBooks = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _errorMessage = '';
  String _searchErrorMessage = '';

  List<BookModel> get books => _books;
  List<BookModel> get searchResults => _searchResults;
  List<BookModel> get savedBooks => List.unmodifiable(_savedBooks);
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get errorMessage => _errorMessage;
  String get searchErrorMessage => _searchErrorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasSearchError => _searchErrorMessage.isNotEmpty;

  bool isBookSaved(BookModel book) {
    return _savedBooks.any((savedBook) => savedBook.id == book.id);
  }

  void toggleSavedBook(BookModel book) {
    final savedIndex = _savedBooks.indexWhere(
      (savedBook) => savedBook.id == book.id,
    );

    if (savedIndex == -1) {
      _savedBooks.add(book);
    } else {
      _savedBooks.removeAt(savedIndex);
    }

    notifyListeners();
  }

  Future<void> loadAllBooks({bool forceRefresh = false}) async {
    if (_books.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _books = await _apiService.fetchBooks();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchBooks(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _searchResults = [];
      _searchErrorMessage = '';
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchErrorMessage = '';
    notifyListeners();

    try {
      _searchResults = await _apiService.searchBooks(trimmedQuery);
    } catch (e) {
      _searchErrorMessage = e.toString();
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
}
