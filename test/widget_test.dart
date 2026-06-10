import 'package:final_mobile/main.dart';
import 'package:final_mobile/providers/book_provider.dart';
import 'package:final_mobile/providers/chat_provider.dart';
import 'package:final_mobile/providers/review_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows book app home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BookProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Book App'), findsOneWidget);
  });
}
