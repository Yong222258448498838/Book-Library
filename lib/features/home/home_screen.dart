import 'dart:ui';

import 'package:final_mobile/data/model/book_model.dart';
import 'package:final_mobile/features/search/book_detail_screen.dart';
import 'package:final_mobile/features/search/search_screen.dart';
import 'package:final_mobile/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = ['Book App', 'Saved Books', 'Settings'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BookProvider>().loadAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 245, 242, 242),
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: false,
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _HomeBooksGrid(),
          _SavedBooksScreen(),
          _SettingsScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(90)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 48, 48).withValues(alpha: 0.10),
                  borderRadius: const BorderRadius.all(Radius.circular(90)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 87, 82, 82).withValues(alpha: 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ).withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BottomNavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Home',
                      isActive: _selectedIndex == 0,
                      onTap: () => _selectTab(0),
                    ),
                    _BottomNavItem(
                      icon: Icons.bookmark_border,
                      activeIcon: Icons.bookmark,
                      label: 'Save Book',
                      isActive: _selectedIndex == 1,
                      onTap: () => _selectTab(1),
                    ),
                    _BottomNavItem(
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings,
                      label: 'Setting',
                      isActive: _selectedIndex == 2,
                      onTap: () => _selectTab(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 64,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBar(isActive: isActive),
              const SizedBox(height: 0),
              Icon(
                isActive ? activeIcon : icon,
                size: 30,
                color: isActive
                    ? const Color.fromARGB(255, 12, 248, 4)
                    : const Color.fromARGB(179, 255, 245, 245),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 15, 220, 8),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}

class _HomeBooksGrid extends StatelessWidget {
  const _HomeBooksGrid();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(provider.errorMessage),
            ),
          );
        }

        if (provider.books.isEmpty) {
          return const Center(child: Text('No books found.'));
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
          itemCount: provider.books.length,
          itemBuilder: (context, index) {
            return BookGridTile(book: provider.books[index]);
          },
        );
      },
    );
  }
}

class BookGridTile extends StatelessWidget {
  final BookModel book;

  const BookGridTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: book.cover.isEmpty
                    ? const Icon(Icons.menu_book, size: 48)
                    : Image.network(
                        book.cover,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.menu_book, size: 48);
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${book.price}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedBooksScreen extends StatefulWidget {
  const _SavedBooksScreen();

  @override
  State<_SavedBooksScreen> createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<_SavedBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        if (provider.savedBooks.isEmpty) {
          return const Center(child: Text('No saved books yet.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: provider.savedBooks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final book = provider.savedBooks[index];

            return ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: SizedBox(
                width: 56,
                height: 72,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: book.cover.isEmpty
                      ? Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.menu_book),
                        )
                      : Image.network(
                          book.cover,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.menu_book),
                            );
                          },
                        ),
                ),
              ),
              title: Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${book.author}\n\$${book.price}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                tooltip: 'Remove saved book',
                icon: const Icon(Icons.bookmark_remove),
                onPressed: () => provider.toggleSavedBook(book),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailScreen(book: book),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings'));
  }
}
