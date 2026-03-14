// lib/screens/messages_page/conversation_state.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/messages_page/chat_models.dart';

class ConversationState extends ChangeNotifier {
  ConversationState._() {
    _initOnlineStatus();
  }
  static final ConversationState instance = ConversationState._();

  // ── Khởi tạo trạng thái online ban đầu ───────────────────────────────────
  void _initOnlineStatus() {
    final now = DateTime.now();
    _onlineSince['Nguyễn Văn A'] = now.subtract(const Duration(seconds: 10));
    _onlineSince['Trần Thị B']   = now.subtract(const Duration(seconds: 6));
    _onlineSince['Phạm Thị D']   = now.subtract(const Duration(seconds: 2));
    _typingContacts.add('Phạm Thị D');
  }

  // ── Online / Offline ──────────────────────────────────────────────────────
  final Map<String, DateTime> _onlineSince = {};
  final Map<String, DateTime> _lastSeenAt  = {};
  final Map<String, Timer>    _offlineTimers = {};

  bool isOnline(String name) => _onlineSince.containsKey(name);
  DateTime? lastSeenAt(String name) => _lastSeenAt[name];

  List<String> get onlineContacts {
    final entries = _onlineSince.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return entries.map((e) => e.key).toList();
  }

  void _setOnline(String name) {
    _offlineTimers[name]?.cancel();
    _offlineTimers.remove(name);
    if (!_onlineSince.containsKey(name)) {
      _onlineSince[name] = DateTime.now();
      notifyListeners();
    }
  }

  void _startOfflineCountdown(String name) {
    _offlineTimers[name]?.cancel();
    _offlineTimers[name] = Timer(const Duration(minutes: 3), () {
      _lastSeenAt[name] = DateTime.now();
      _onlineSince.remove(name);
      _offlineTimers.remove(name);
      notifyListeners();
    });
  }

  // ── Thứ tự danh sách ─────────────────────────────────────────────────────
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

  // ── Typing + auto-reply ───────────────────────────────────────────────────
  final Set<String>        _typingContacts = {};
  final Map<String, Timer> _replyTimers    = {};

  bool isTyping(String name) => _typingContacts.contains(name);

  void scheduleReply(String contactName, String replyText) {
    _setOnline(contactName);
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
      _manualUnread.add(contactName);

      updateReplyPreview(contactName, replyText);
      _pushToTop(contactName);
      _startOfflineCountdown(contactName);
    });
  }

  void cancelReply(String name) {
    _replyTimers[name]?.cancel();
    _replyTimers.remove(name);
    _typingContacts.remove(name);
    notifyListeners();
  }

  // ── Lịch sử ──────────────────────────────────────────────────────────────
  final Map<String, List<ChatMessage>> _histories = {};

  bool hasHistory(String name) => _histories.containsKey(name);
  List<ChatMessage> getHistory(String name) => List.from(_histories[name] ?? []);
  void saveHistory(String name, List<ChatMessage> messages) {
    _histories[name] = List.from(messages);
  }

  // ── Preview ───────────────────────────────────────────────────────────────
  final Map<String, String> _previews = {};

  String? getPreview(String name) => _previews[name];

  void updateReplyPreview(String name, String message) {
    _previews[name] = message;
    notifyListeners();
  }

  void updateReactionPreview(String name, String emoji, String snippet) {
    final s = snippet.length > 20 ? '${snippet.substring(0, 20)}...' : snippet;
    _previews[name] = 'Đã bày tỏ cảm xúc $emoji về "$s"';
    // ✅ Thả emote = hoạt động mới → đưa lên đầu danh sách
    _pushToTop(name);
    notifyListeners();
  }

  void restoreLastMessagePreview(String name, String lastMessage) {
    _previews[name] = lastMessage;
    notifyListeners();
  }

  // ── Đã đọc / Chưa đọc ────────────────────────────────────────────────────
  final Set<String> _readContacts  = {};
  final Set<String> _manualUnread  = {};
  final Set<String> _unreadReplies = {};

  bool isRead(String name) =>
      _readContacts.contains(name) && !_manualUnread.contains(name);

  void markAsRead(String name) {
    _readContacts.add(name);
    _manualUnread.remove(name);
    _unreadReplies.remove(name);
    notifyListeners();
  }

  void markAsUnread(String name) {
    _manualUnread.add(name);
    notifyListeners();
  }

  bool isManuallyUnread(String name) => _manualUnread.contains(name);
  bool hasUnreadReply(String name)   => _unreadReplies.contains(name);

  bool isEffectivelyUnread(String name, bool initialUnread) =>
      (initialUnread && !_readContacts.contains(name)) ||
          hasUnreadReply(name) ||
          isManuallyUnread(name);

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

  // ── Helper: format last-seen ──────────────────────────────────────────────
  /// [isEn] = true → trả về tiếng Anh, false → tiếng Việt (mặc định)
  String? getActivityStatus(String name, {bool isEn = false}) {
    if (isOnline(name)) {
      return isEn ? 'Active now' : 'Đang hoạt động';
    }
    final seen = _lastSeenAt[name];
    if (seen == null) return null; // caller tự xử lý fallback
    final diff = DateTime.now().difference(seen);
    if (diff.inMinutes < 1) {
      return isEn ? 'Active just now' : 'Vừa hoạt động';
    }
    if (diff.inMinutes < 60) {
      return isEn
          ? 'Active ${diff.inMinutes}m ago'
          : 'Hoạt động ${diff.inMinutes} phút trước';
    }
    if (diff.inHours < 24) {
      return isEn
          ? 'Active ${diff.inHours}h ago'
          : 'Hoạt động ${diff.inHours} giờ trước';
    }
    return null;
  }
}