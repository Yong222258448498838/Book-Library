import 'package:final_mobile/features/home/home_screen.dart';
import 'package:final_mobile/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    await context.read<BookProvider>().searchBooks(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Search Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search by title',
                    ),
                    onChanged: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.search), onPressed: _search),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, provider, child) {
                if (provider.isSearching) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.hasSearchError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(provider.searchErrorMessage),
                    ),
                  );
                }

                if (provider.searchResults.isEmpty) {
                  return const Center(child: Text('No search results.'));
                }

                return GridView.builder(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    return BookGridTile(book: provider.searchResults[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
