// lib/screens/messages_page/conversation_state.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/messages_page/chat_models.dart';

class ConversationState extends ChangeNotifier {
  ConversationState._() {
    _typingContacts.add('Phạm Thị D');
  }
  static final ConversationState instance = ConversationState._();

  // ── Thứ tự hiển thị ──────────────────────────────────────────────────────
  final List<String> _order = [
    'Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D',
    'Hoàng Văn E', 'Vũ Thị F', 'Đặng Văn G', 'Bùi Thị H',
  ];

  List<String> get contactOrder => List.unmodifiable(_order);

  void _pushToTop(String name) {
    _order.remove(name);
    final insertAt = isPinned(name)
        ? 0
        : () {
      final i = _order.indexWhere((n) => !isPinned(n));
      return i == -1 ? _order.length : i;
    }();
    _order.insert(insertAt, name);
  }

  // ── Typing + auto-reply ──────────────────────────────────────────────────
  final Set<String> _typingContacts = {};
  final Map<String, Timer> _replyTimers = {};

  bool isTyping(String name) => _typingContacts.contains(name);

  void scheduleReply(String contactName, String replyText) {
    _typingContacts.add(contactName);
    notifyListeners();

    _replyTimers[contactName]?.cancel();
    _replyTimers[contactName] = Timer(const Duration(seconds: 10), () {
      _typingContacts.remove(contactName);

      final history = List<ChatMessage>.from(_histories[contactName] ?? []);
      history.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: replyText,
        isMe: false,
        time: DateTime.now(),
        status: MessageStatus.seen,
      ));
      _histories[contactName] = history;

      _unreadReplies.add(contactName);
      // Khi có reply mới → cũng coi là chưa đọc thủ công
      _manualUnread.add(contactName);

      updateReplyPreview(contactName, replyText);
      _pushToTop(contactName);
    });
  }

  void cancelReply(String name) {
    _replyTimers[name]?.cancel();
    _replyTimers.remove(name);
    _typingContacts.remove(name);
    notifyListeners();
  }

  // ── Lịch sử ─────────────────────────────────────────────────────────────
  final Map<String, List<ChatMessage>> _histories = {};

  bool hasHistory(String name) => _histories.containsKey(name);
  List<ChatMessage> getHistory(String name) => List.from(_histories[name] ?? []);
  void saveHistory(String name, List<ChatMessage> messages) {
    _histories[name] = List.from(messages);
  }

  // ── Preview ──────────────────────────────────────────────────────────────
  final Map<String, String> _previews = {};

  String? getPreview(String name) => _previews[name];

  void updateReplyPreview(String name, String message) {
    _previews[name] = message;
    notifyListeners();
  }

  void updateReactionPreview(String name, String emoji, String snippet) {
    final s = snippet.length > 20 ? '${snippet.substring(0, 20)}...' : snippet;
    _previews[name] = 'Đã bày tỏ cảm xúc $emoji về "$s"';
    notifyListeners();
  }

  void restoreLastMessagePreview(String name, String lastMessage) {
    _previews[name] = lastMessage;
    notifyListeners();
  }

  // ── Đã đọc / Chưa đọc ───────────────────────────────────────────────────
  final Set<String> _readContacts = {};
  /// Danh sách bị đánh dấu chưa đọc THỦ CÔNG (qua menu "Khác")
  final Set<String> _manualUnread = {};

  bool isRead(String name) =>
      _readContacts.contains(name) && !_manualUnread.contains(name);

  void markAsRead(String name) {
    _readContacts.add(name);
    _manualUnread.remove(name);
    _unreadReplies.remove(name);
    notifyListeners();
  }

  /// ✅ Đánh dấu chưa đọc thủ công → hiện chấm xanh + vào tab "Chưa đọc"
  void markAsUnread(String name) {
    _manualUnread.add(name);
    notifyListeners();
  }

  bool isManuallyUnread(String name) => _manualUnread.contains(name);

  // ── Reply chưa đọc ───────────────────────────────────────────────────────
  final Set<String> _unreadReplies = {};

  bool hasUnreadReply(String name) => _unreadReplies.contains(name);

  bool isEffectivelyUnread(String name, bool initialUnread) {
    return (initialUnread && !_readContacts.contains(name)) ||
        hasUnreadReply(name) ||
        isManuallyUnread(name);
  }

  // ── Ghim ─────────────────────────────────────────────────────────────────
  final Set<String> _pinnedContacts = {};

  bool isPinned(String name) => _pinnedContacts.contains(name);
  void togglePin(String name) {
    _pinnedContacts.contains(name)
        ? _pinnedContacts.remove(name)
        : _pinnedContacts.add(name);
    notifyListeners();
  }

  // ── Lưu trữ ──────────────────────────────────────────────────────────────
  final Set<String> _archivedContacts = {};

  bool isArchived(String name) => _archivedContacts.contains(name);
  void toggleArchive(String name) {
    _archivedContacts.contains(name)
        ? _archivedContacts.remove(name)
        : _archivedContacts.add(name);
    notifyListeners();
  }
}










