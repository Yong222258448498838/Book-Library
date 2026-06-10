class ChatMessageModel {
  final String text;
  final bool isFromMe;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.text,
    required this.isFromMe,
    required this.createdAt,
  });
}
