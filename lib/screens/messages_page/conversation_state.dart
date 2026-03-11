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
    // 3 người online ngay từ đầu, stagger nhau vài giây để có thứ tự
    _onlineSince['Nguyễn Văn A'] = now.subtract(const Duration(seconds: 10));
    _onlineSince['Trần Thị B']   = now.subtract(const Duration(seconds: 6));
    _onlineSince['Phạm Thị D']   = now.subtract(const Duration(seconds: 2));
    // Typing ban đầu
    _typingContacts.add('Phạm Thị D');
  }

  // ── Online / Offline ──────────────────────────────────────────────────────
  /// name → thời điểm online (để sắp xếp thứ tự trong story row)
  final Map<String, DateTime> _onlineSince = {};
  /// name → thời điểm offline gần nhất
  final Map<String, DateTime> _lastSeenAt  = {};
  /// timer chờ 3 phút rồi tự offline
  final Map<String, Timer> _offlineTimers  = {};

  bool isOnline(String name) => _onlineSince.containsKey(name);

  DateTime? lastSeenAt(String name) => _lastSeenAt[name];

  /// Danh sách người đang online, sắp xếp theo thứ tự online (cũ → mới)
  List<String> get onlineContacts {
    final entries = _onlineSince.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return entries.map((e) => e.key).toList();
  }

  /// Đặt contact là online (huỷ timer offline nếu có)
  void _setOnline(String name) {
    _offlineTimers[name]?.cancel();
    _offlineTimers.remove(name);
    if (!_onlineSince.containsKey(name)) {
      _onlineSince[name] = DateTime.now();
      notifyListeners();
    }
  }

  /// Bắt đầu đếm ngược 3 phút → offline
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
  final Set<String> _typingContacts = {};
  final Map<String, Timer> _replyTimers = {};

  bool isTyping(String name) => _typingContacts.contains(name);

  void scheduleReply(String contactName, String replyText) {
    // Khi bắt đầu typing → online
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

      // Sau khi reply xong → bắt đầu đếm 3 phút rồi offline
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
  /// Trả về chuỗi hiển thị trạng thái hoạt động.
  /// Nếu đang online → "Đang hoạt động"
  /// Nếu offline, tính từ [lastSeenAt]:
  ///   < 1 phút  → "Vừa hoạt động"
  ///   < 60 phút → "Hoạt động X phút trước"
  ///   < 24 giờ  → "Hoạt động X giờ trước"
  ///   >= 1 ngày → null (caller tự xử lý)
  String? getActivityStatus(String name) {
    if (isOnline(name)) return 'Đang hoạt động';
    final seen = _lastSeenAt[name];
    if (seen == null) return null;
    final diff = DateTime.now().difference(seen);
    if (diff.inMinutes < 1)  return 'Vừa hoạt động';
    if (diff.inMinutes < 60) return 'Hoạt động ${diff.inMinutes} phút trước';
    if (diff.inHours < 24)   return 'Hoạt động ${diff.inHours} giờ trước';
    return null; // > 1 ngày: không hiển thị
  }
}