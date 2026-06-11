import 'package:final_mobile/core/widgets/connectivity_wrapper.dart';
import 'package:final_mobile/features/home/home_screen.dart';
import 'package:final_mobile/providers/book_provider.dart';
import 'package:final_mobile/providers/chat_provider.dart';
import 'package:final_mobile/providers/review_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ConnectivityWrapper(
        child: HomeScreen(),
      ),
    );
  }
}
