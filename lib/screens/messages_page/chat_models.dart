class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageStatus status;
  final Map<String, int> reactions;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.status = MessageStatus.sent,
    Map<String, int>? reactions,
  }) : reactions = reactions ?? {};

  ChatMessage copyWith({MessageStatus? status, Map<String, int>? reactions}) =>
      ChatMessage(
        id: id,
        text: text,
        isMe: isMe,
        time: time,
        status: status ?? this.status,
        reactions: reactions ?? Map.from(this.reactions),
      );
}

enum MessageStatus { sending, sent, delivered, seen }