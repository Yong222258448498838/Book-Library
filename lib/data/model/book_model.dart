class BookModel {
  final String id;
  final String title;
  final String decription; // Matching your MockAPI spelling
  final String cover;
  final String price;
  final String author;

  BookModel({
    required this.id,
    required this.title,
    required this.decription,
    required this.cover,
    required this.price,
    required this.author,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      decription: json['decription'] ?? '', // Handles your exact schema key
      cover: json['cover'] ?? 'https://placeholder.com',
      price: json['price'] ?? '0.00',
      author: json['author'] ?? 'Unknown Author',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'decription': decription,
      'cover': cover,
      'price': price,
      'author': author,
    };
  }
}
