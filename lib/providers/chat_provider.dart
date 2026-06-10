import 'package:final_mobile/data/model/chat_message_model.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessageModel> _messages = [];

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  void sendMessage(String text) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    _messages.add(
      ChatMessageModel(
        text: cleanText,
        isFromMe: true,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
